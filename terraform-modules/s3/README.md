# S3 Module

Reusable Terraform module for creating an Amazon S3 bucket with versioning, encryption, lifecycle policies, and CORS configuration.

## Usage

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
