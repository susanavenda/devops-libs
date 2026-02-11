# RDS Module
# Creates an RDS instance with subnet group, parameter group, and security group

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-subnet-group"
    }
  )
}

# DB Parameter Group
resource "aws_db_parameter_group" "main" {
  count = var.create_parameter_group ? 1 : 0

  family = var.parameter_group_family
  name   = "${var.name}-parameter-group"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-parameter-group"
    }
  )
}

# DB Security Group
resource "aws_security_group" "db" {
  name        = "${var.name}-db-sg"
  description = "Security group for ${var.name} RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
    cidr_blocks     = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-db-sg"
    }
  )
}

# Random password for master user
resource "random_password" "master_password" {
  count   = var.create_random_password ? 1 : 0
  length  = 16
  special = true
}

# DB Instance
resource "aws_db_instance" "main" {
  identifier = var.name

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type         = var.storage_type
  storage_encrypted     = var.storage_encrypted
  kms_key_id           = var.kms_key_id

  db_name  = var.db_name
  username = var.username
  password = var.create_random_password ? random_password.master_password[0].result : var.password
  port     = var.port

  db_subnet_group_name   = aws_db_subnet_group.main.name
  parameter_group_name   = var.create_parameter_group ? aws_db_parameter_group.main[0].name : null
  vpc_security_group_ids = [aws_security_group.db.id]

  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.name}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  deletion_protection       = var.deletion_protection

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  performance_insights_enabled    = var.performance_insights_enabled

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

# DB Instance Read Replica (optional)
resource "aws_db_instance" "replica" {
  count = var.create_read_replica ? 1 : 0

  identifier = "${var.name}-replica"

  replicate_source_db = aws_db_instance.main.identifier
  instance_class      = var.replica_instance_class

  publicly_accessible = var.replica_publicly_accessible
  storage_encrypted   = var.storage_encrypted

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-replica"
    }
  )
}
