# EKS Cluster Module

Reusable Terraform module for creating an Amazon EKS cluster with best practices.

## Usage

```hcl
module "eks_cluster" {
  source = "github.com/susanavenda/devops-toolkit//terraform/modules/eks-cluster?ref=v1.0.0"

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

## Requirements

- Terraform >= 1.0
- AWS Provider >= 5.0

## Inputs

See `variables.tf` for all available inputs.

## Outputs

See `outputs.tf` for all available outputs.
