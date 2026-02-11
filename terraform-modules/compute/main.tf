# Compute Module - Automatically provisions compute resources based on app_type
# Developers don't need to know about ECS, EKS, Lambda, etc. - it's automatic

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "app_type" {
  description = "Application type (web, api, microservice, static-site, containerized)"
  type        = string
}

variable "runtime" {
  description = "Runtime (nodejs, java, python, go, dotnet)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "min_instances" {
  description = "Minimum instances"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Maximum instances"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}

# Automatically select compute type based on app_type
locals {
  # Web/API apps use ECS Fargate
  use_ecs = contains(["web", "api", "microservice"], var.app_type)
  
  # Static sites use S3 + CloudFront
  use_s3 = var.app_type == "static-site"
  
  # Serverless APIs use Lambda
  use_lambda = var.app_type == "api" && var.runtime == "nodejs"
  
  # Containerized apps use ECS
  use_container = var.app_type == "containerized"
}

# ECS Cluster for web/api/microservice apps
resource "aws_ecs_cluster" "main" {
  count = local.use_ecs || local.use_container ? 1 : 0
  
  name = "${var.project_name}-${var.environment}"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  
  tags = var.tags
}

# ECS Task Definition - Automatically configured for runtime
# Optimized for cost and performance
resource "aws_ecs_task_definition" "app" {
  count = local.use_ecs || local.use_container ? 1 : 0
  
  family                   = "${var.project_name}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"  # Optimized: Start small, scale up as needed
  memory                   = "512"  # Optimized: Right-sized for most workloads
  execution_role_arn      = aws_iam_role.ecs_execution[0].arn
  task_role_arn           = aws_iam_role.ecs_task[0].arn
  
  container_definitions = jsonencode([{
    name  = "${var.project_name}-app"
    image = "${var.project_name}:latest"  # Image is built and pushed automatically
    
    portMappings = [{
      containerPort = 8080
      protocol      = "tcp"
    }]
    
    environment = [
      {
        name  = "ENVIRONMENT"
        value = var.environment
      }
    ]
    
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.app[0].name
        "awslogs-region"        = data.aws_region.current.name
        "awslogs-stream-prefix" = "ecs"
      }
    }
    
    healthCheck = {
      command     = ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 60
    }
  }])
  
  tags = var.tags
}

# ECS Service with auto-scaling
resource "aws_ecs_service" "app" {
  count = local.use_ecs || local.use_container ? 1 : 0
  
  name            = "${var.project_name}-${var.environment}"
  cluster         = aws_ecs_cluster.main[0].id
  task_definition = aws_ecs_task_definition.app[0].arn
  desired_count   = var.min_instances
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets          = data.aws_subnets.private.ids
    security_groups  = [aws_security_group.ecs[0].id]
    assign_public_ip = false
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.app[0].arn
    container_name   = "${var.project_name}-app"
    container_port   = 8080
  }
  
  tags = var.tags
}

# Auto-scaling configuration
resource "aws_appautoscaling_target" "ecs_target" {
  count = local.use_ecs || local.use_container ? 1 : 0
  
  max_capacity       = var.max_instances
  min_capacity       = var.min_instances
  resource_id        = "service/${aws_ecs_cluster.main[0].name}/${aws_ecs_service.app[0].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  count = local.use_ecs || local.use_container ? 1 : 0
  
  name               = "${var.project_name}-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace
  
  target_tracking_scaling_policy_configuration {
    target_value       = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

# S3 + CloudFront for static sites
resource "aws_s3_bucket" "static_site" {
  count = local.use_s3 ? 1 : 0
  
  bucket = "${var.project_name}-${var.environment}-static"
  
  tags = var.tags
}

# Lambda for serverless APIs
resource "aws_lambda_function" "api" {
  count = local.use_lambda ? 1 : 0
  
  function_name = "${var.project_name}-${var.environment}"
  runtime       = var.runtime == "nodejs" ? "nodejs20.x" : "python3.11"
  handler      = "index.handler"
  role         = aws_iam_role.lambda[0].arn
  
  # Code is deployed automatically
  filename         = "${var.project_name}.zip"
  source_code_hash = filebase64sha256("${var.project_name}.zip")
  
  tags = var.tags
}

# Outputs
output "target_group_id" {
  value = local.use_ecs || local.use_container ? aws_lb_target_group.app[0].id : null
}

output "arn" {
  value = local.use_ecs || local.use_container ? aws_ecs_service.app[0].id : (local.use_lambda ? aws_lambda_function.api[0].arn : null)
}

# Data sources and supporting resources
data "aws_region" "current" {}
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  tags = {
    Type = "private"
  }
}

resource "aws_security_group" "ecs" {
  count = local.use_ecs || local.use_container ? 1 : 0
  
  name        = "${var.project_name}-ecs-${var.environment}"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = var.tags
}

resource "aws_lb_target_group" "app" {
  count = local.use_ecs || local.use_container ? 1 : 0
  
  name     = "${var.project_name}-${var.environment}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/health"
    protocol            = "HTTP"
  }
  
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "app" {
  count = local.use_ecs || local.use_container || local.use_lambda ? 1 : 0
  
  name              = "/ecs/${var.project_name}-${var.environment}"
  retention_in_days = 30
  
  tags = var.tags
}

resource "aws_iam_role" "ecs_execution" {
  count = local.use_ecs || local.use_container ? 1 : 0
  
  name = "${var.project_name}-ecs-execution-${var.environment}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
  
  tags = var.tags
}

resource "aws_iam_role" "ecs_task" {
  count = local.use_ecs || local.use_container ? 1 : 0
  
  name = "${var.project_name}-ecs-task-${var.environment}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
  
  tags = var.tags
}

resource "aws_iam_role" "lambda" {
  count = local.use_lambda ? 1 : 0
  
  name = "${var.project_name}-lambda-${var.environment}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
  
  tags = var.tags
}
