# Terraform Modules

Reusable AWS infrastructure modules: VPC, EKS, RDS, S3.

## Modules

- **vpc** - VPC with public/private subnets, NAT Gateway
- **eks-cluster** - EKS Kubernetes cluster
- **rds** - RDS PostgreSQL
- **s3** - S3 bucket with versioning, lifecycle

## Usage

```hcl
module "vpc" {
  source = "git::https://github.com/org/devops-platform//packages/terraform-modules/vpc?ref=main"
  # Or local: source = "../../packages/terraform-modules/vpc"
  name               = "myapp-vpc"
  cidr_block         = "10.0.0.0/16"
  availability_zones  = ["eu-west-1a", "eu-west-1b"]
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  enable_nat_gateway  = true
}
```
