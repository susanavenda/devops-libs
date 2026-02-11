# GitHub Workflows

Reusable CI/CD workflows: Golden Pipeline, security scans, infrastructure provisioning.

## Workflows

- **golden-pipeline.yml** - Language-agnostic build, test, security
- **infrastructure-security.yml** - Checkov, Terrascan, TFLint
- **release.yml** - Release on tag push
- **docker-build.yml** - Container build

## Usage

From app repo `.github/workflows/ci.yml`:

```yaml
jobs:
  pipeline:
    uses: ./packages/github-workflows/workflows/golden-pipeline.yml
    with:
      language: java
      runtime-version: '21'
```

Or from separate repo (replace with your org/repo):
```yaml
uses: org/devops-platform//packages/github-workflows/workflows/golden-pipeline.yml@main
```
