# DevOps Libs

**Independent reusable library** for DevOps tooling. Consumed by applications via git ref.

```
git::https://github.com/org/devops-libs//terraform-modules/vpc?ref=main
```

## Contents

| Path | Description |
|------|-------------|
| terraform-modules/ | VPC, EKS, RDS, S3 |
| github-workflows/ | Golden Pipeline, security, CI/CD |
| docker-templates/ | Java, Python, Node Dockerfiles |
| kubernetes-templates/ | Deployment, Service, Ingress |
| observability-config/ | Prometheus, Grafana |
| ansible/ | Playbooks, roles |
| scripts/ | Deploy, health-check, backup |
| project-templates/ | .gitignore, dependabot, config |

## Consumption

### Terraform
```hcl
source = "git::https://github.com/org/devops-libs//terraform-modules/vpc?ref=main"
```

### GitHub Actions
```yaml
uses: org/devops-libs//github-workflows/workflows/golden-pipeline.yml@main
```

Pin to `?ref=v1.0.0` for production.
