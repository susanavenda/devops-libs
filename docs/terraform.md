# Terraform Modules Guide

How to use Terraform modules from this toolkit.

## EKS Cluster Module

### Basic Usage

```hcl
module "eks_cluster" {
  source = "github.com/susanavenda/devops-toolkit//terraform/modules/eks-cluster?ref=main"

  cluster_name      = "my-eks-cluster"
  kubernetes_version = "1.28"
  subnet_ids        = ["subnet-12345", "subnet-67890"]

  node_groups = {
    general = {
      instance_types  = ["t3.medium"]
      capacity_type   = "ON_DEMAND"
      disk_size       = 20
      ami_type        = "AL2_x86_64"
      desired_size    = 2
      max_size        = 4
      min_size        = 1
      max_unavailable = 1
      labels = {
        role = "general"
      }
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## VPC Module

### Basic Usage

```hcl
module "vpc" {
  source = "github.com/susanavenda/devops-toolkit//terraform/modules/vpc?ref=main"

  name       = "my-vpc"
  cidr_block = "10.0.0.0/16"

  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
}
```

## RDS Module

### Basic Usage

```hcl
module "rds" {
  source = "github.com/susanavenda/devops-toolkit//terraform/modules/rds?ref=main"

  name          = "my-database"
  engine        = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.small"

  db_name  = "mydb"
  username = "admin"
  create_random_password = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  allowed_security_group_ids = [module.eks.cluster_security_group_id]
}
```

## S3 Module

### Basic Usage

```hcl
module "s3" {
  source = "github.com/susanavenda/devops-toolkit//terraform/modules/s3?ref=main"

  bucket_name      = "my-bucket-name"
  enable_versioning = true

  lifecycle_rules = [
    {
      id      = "delete-old-files"
      enabled = true
      expiration_days = 90
      noncurrent_version_expiration_days = 30
      transitions = []
    }
  ]
}
```

## Requirements

- Terraform >= 1.0
- AWS Provider >= 5.0
- Random Provider >= 3.0 (for RDS module)

## Module Inputs

See each module's `variables.tf` file for complete input documentation.

## Module Outputs

See each module's `outputs.tf` file for available outputs.

## Best Practices

1. Pin versions: Always pin to a specific version tag
2. Use variables: Don't hardcode values
3. Tag resources: Always include proper tags
4. Review changes: Always run `terraform plan` before applying
5. Use workspaces: Separate environments using workspaces

## Examples

See `terraform/examples/` directory for complete usage examples.
