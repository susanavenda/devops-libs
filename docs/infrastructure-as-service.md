# Infrastructure as Service (IaS)

## Overview

Infrastructure is now completely abstracted away from developers. They simply use a template file, and all infrastructure is automatically provisioned, configured, and managed.

## How It Works

### For Developers

**Step 1:** Create `infrastructure-template.yml` in your project root:

```yaml
project:
  name: my-awesome-app
  environment: production

application:
  type: web
  runtime: nodejs
  port: 8080

scaling:
  min-instances: 1
  max-instances: 5

database:
  enabled: true
  type: postgresql
```

**Step 2:** Push to GitHub

**Step 3:** That's it! Infrastructure is automatically provisioned.

### What Happens Automatically

1. **Infrastructure Detection**
   - System detects your project type (web, api, microservice, etc.)
   - Detects runtime (nodejs, java, python, etc.)
   - Reads your `infrastructure-template.yml`

2. **Infrastructure Provisioning**
   - VPC and networking automatically created
   - Compute resources (ECS/EKS/Lambda) automatically selected
   - Load balancer automatically configured
   - Database automatically provisioned (if enabled)
   - Storage automatically configured (if enabled)
   - Security groups and IAM roles automatically created
   - Monitoring and logging automatically set up

3. **Deployment**
   - Your application is automatically deployed to the infrastructure
   - Health checks automatically configured
   - Auto-scaling automatically enabled
   - SSL certificates automatically provisioned

## Infrastructure Template

### Minimal Template

```yaml
project:
  name: my-app

application:
  type: web
  runtime: nodejs
```

This is enough! Everything else uses sensible defaults.

### Full Template Options

```yaml
project:
  name: my-app
  environment: production  # production, staging, development

application:
  type: web  # web, api, microservice, static-site, containerized
  runtime: nodejs  # nodejs, java, python, go, dotnet
  port: 8080
  health-check-path: /health

scaling:
  min-instances: 1
  max-instances: 5
  target-cpu: 70

database:
  enabled: true
  type: postgresql  # postgresql, mysql, mongodb
  size: medium  # small, medium, large

storage:
  enabled: true
  type: s3  # s3, ebs
  size-gb: 50

networking:
  domain: myapp.com  # Optional custom domain
  ssl-enabled: true
  cdn-enabled: true

monitoring:
  enabled: true
  log-retention-days: 30
  alerting-enabled: true

security:
  secrets-management: true
  encryption-at-rest: true
  encryption-in-transit: true
```

## Application Types

### Web Application (`type: web`)
- **Infrastructure:** ECS Fargate
- **Auto-scaling:** Enabled
- **Load Balancer:** Application Load Balancer
- **SSL:** Automatic
- **Best for:** React, Vue, Angular apps

### API (`type: api`)
- **Infrastructure:** ECS Fargate or Lambda (auto-selected)
- **Auto-scaling:** Enabled
- **Load Balancer:** API Gateway + ALB
- **Best for:** REST APIs, GraphQL APIs

### Microservice (`type: microservice`)
- **Infrastructure:** ECS Fargate
- **Service Mesh:** Automatically configured
- **Best for:** Microservices architecture

### Static Site (`type: static-site`)
- **Infrastructure:** S3 + CloudFront
- **CDN:** Automatically enabled
- **SSL:** Automatic
- **Best for:** Jekyll, Hugo, Gatsby sites

### Containerized (`type: containerized`)
- **Infrastructure:** ECS Fargate or EKS (auto-selected)
- **Best for:** Docker-based applications

## Automatic Infrastructure Selection

The system automatically selects the best infrastructure based on your configuration:

| App Type | Runtime | Infrastructure | Why |
|----------|---------|----------------|-----|
| web | nodejs | ECS Fargate | Best for web apps |
| api | nodejs | Lambda | Serverless, cost-effective |
| api | java | ECS Fargate | Better for Java workloads |
| static-site | any | S3 + CloudFront | Perfect for static content |
| microservice | any | ECS Fargate | Service mesh support |

## Workflows

### Auto-Provision Workflow

Triggered automatically when:
- `infrastructure-template.yml` is created or modified
- Pushed to main branch

**What it does:**
1. Reads your template
2. Detects project configuration
3. Provisions infrastructure
4. Configures deployment pipeline

### Deploy Workflow

Triggered automatically when:
- Code is pushed
- Pull request is merged

**What it does:**
1. Builds your application
2. Deploys to provisioned infrastructure
3. Runs health checks
4. Updates DNS/load balancer

## Benefits

### For Developers
- ✅ **Zero Infrastructure Knowledge Required** - Just fill a template
- ✅ **Fast Setup** - Infrastructure ready in minutes
- ✅ **No Manual Configuration** - Everything is automatic
- ✅ **Best Practices Built-In** - Security, scaling, monitoring included
- ✅ **Focus on Code** - No infrastructure distractions

### For Organizations
- ✅ **Consistency** - All projects use same infrastructure patterns
- ✅ **Security** - Security best practices enforced automatically
- ✅ **Cost Optimization** - Right-sized resources automatically
- ✅ **Compliance** - Infrastructure meets compliance requirements
- ✅ **Maintainability** - Single source of truth for infrastructure

## Examples

### Simple Web App

```yaml
# infrastructure-template.yml
project:
  name: my-web-app

application:
  type: web
  runtime: nodejs
```

**Result:** Full production infrastructure with:
- ECS Fargate cluster
- Application Load Balancer
- Auto-scaling (1-3 instances)
- SSL certificate
- CloudWatch monitoring
- Log aggregation

### API with Database

```yaml
# infrastructure-template.yml
project:
  name: my-api

application:
  type: api
  runtime: nodejs

database:
  enabled: true
  type: postgresql
  size: medium
```

**Result:** API infrastructure with:
- Lambda functions (serverless)
- API Gateway
- RDS PostgreSQL database
- VPC with private subnets
- Secrets Manager for credentials

### Static Site

```yaml
# infrastructure-template.yml
project:
  name: my-blog

application:
  type: static-site
  runtime: nodejs  # Not used, but required

networking:
  domain: myblog.com
  cdn-enabled: true
```

**Result:** Static site infrastructure with:
- S3 bucket for hosting
- CloudFront CDN
- Custom domain with SSL
- Global distribution

## Customization

### Override Defaults

Set GitHub Variables in repository settings:

- `INFRASTRUCTURE_REGION` - AWS region (default: us-east-1)
- `INFRASTRUCTURE_PROVIDER` - Cloud provider (default: aws)
- `AUTO_SCALE_ENABLED` - Enable/disable auto-scaling
- `MONITORING_PROVIDER` - Monitoring service (default: cloudwatch)

### Advanced Configuration

For advanced use cases, you can still customize:

1. **Custom Terraform Modules** - Add to `terraform/modules/`
2. **Custom Templates** - Create `terraform/templates/custom/`
3. **Workflow Customization** - Extend workflows in `.github/workflows/`

## Troubleshooting

### Infrastructure Not Provisioning

1. Check `infrastructure-template.yml` exists
2. Verify template syntax is valid YAML
3. Check GitHub Actions logs
4. Verify AWS credentials are configured

### Wrong Infrastructure Type

1. Check `application.type` in template
2. Verify `application.runtime` matches your project
3. Review auto-detection logs in workflow

### Cost Concerns

1. Set `min-instances: 0` for development
2. Use `type: api` with Lambda for cost-effective APIs
3. Enable `cdn-enabled: true` to reduce compute costs

## Migration Guide

### Existing Projects

1. **Create template:**
   ```bash
   cp devops-toolkit/templates/infrastructure-template.yml .
   ```

2. **Fill in your values:**
   - Project name
   - Application type
   - Runtime

3. **Commit and push:**
   ```bash
   git add infrastructure-template.yml
   git commit -m "feat: add infrastructure template"
   git push
   ```

4. **Infrastructure auto-provisions!**

### Removing Manual Infrastructure

1. Export existing infrastructure state
2. Import into new IaS system
3. Remove manual Terraform files
4. Use template going forward

## Best Practices

1. **Start Simple** - Use minimal template, add features as needed
2. **Version Control Templates** - Commit `infrastructure-template.yml`
3. **Environment Separation** - Use different templates for dev/staging/prod
4. **Review Auto-Provisioned Resources** - Check AWS console after provisioning
5. **Monitor Costs** - Review CloudWatch billing dashboard

## Support

- **Documentation:** See `devops-toolkit/docs/`
- **Templates:** See `devops-toolkit/templates/`
- **Examples:** See `devops-toolkit/examples/`

## Future Enhancements

- [ ] Multi-cloud support (AWS, Azure, GCP)
- [ ] Infrastructure cost estimation
- [ ] One-click infrastructure cloning
- [ ] Infrastructure visualization dashboard
- [ ] Cost optimization recommendations
