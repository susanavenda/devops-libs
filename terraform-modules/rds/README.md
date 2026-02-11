# RDS Module

Reusable Terraform module for creating an Amazon RDS instance with best practices.

## Usage

```hcl
module "rds" {
  source = "github.com/susanavenda/devops-toolkit//terraform/modules/rds?ref=v1.0.0"

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

  backup_retention_period = 7
  deletion_protection     = true

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Requirements

- Terraform >= 1.0
- AWS Provider >= 5.0
- Random Provider >= 3.0 (for random passwords)

## Inputs

See `variables.tf` for all available inputs.

## Outputs

See `outputs.tf` for all available outputs.
