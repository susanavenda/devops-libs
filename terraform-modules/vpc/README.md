# VPC Module

Reusable Terraform module for creating an Amazon VPC with public and private subnets, NAT Gateway, and Internet Gateway.

## Usage

```hcl
module "vpc" {
  source = "github.com/susanavenda/devops-toolkit//terraform/modules/vpc?ref=main"

  name       = "my-vpc"
  cidr_block = "10.0.0.0/16"

  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Requirements

- Terraform >= 1.0
- AWS Provider >= 5.0

## Inputs

See `variables.tf` for all available inputs.

## Outputs

See `outputs.tf` for all available outputs.
