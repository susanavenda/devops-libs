# Golden Pipeline Interface

## Overview

The Golden Pipeline is a standardized, language-agnostic interface for CI/CD pipelines that implements DevSecOps best practices. Projects implement this interface by configuring inputs rather than writing custom workflows.

## Interface Contract

All projects must implement the Golden Pipeline interface, which provides:

### Required Configuration
- **Language/Framework:** Specify the primary language
- **Build Commands:** Define how to build, test, and lint
- **Artifact Paths:** Define where build outputs are located

### Optional Configuration
- **Security Scanning:** Enable/disable specific security scans
- **Quality Gates:** Set minimum coverage thresholds
- **Custom Commands:** Override default commands

## Implementation Pattern

### Standard Implementation

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  pipeline:
    uses: susanavenda/devops-toolkit/.github/workflows/golden-pipeline.yml@main
    with:
      # Required: Language identification
      language: nodejs  # Options: nodejs, java, python, go, dotnet
      runtime-version: '20'
      
      # Required: Build commands
      install-command: 'npm ci'
      build-command: 'npm run build'
      test-command: 'npm test'
      lint-command: 'npm run lint'
      
      # Optional: Paths
      working-directory: '.'
      build-artifacts-path: 'dist'
      coverage-path: 'coverage/lcov.info'
      
      # Optional: Security configuration
      enable-sast: true
      enable-dependency-scan: true
      enable-secrets-scan: true
      enable-container-scan: true
      enable-infrastructure-scan: true
      
      # Optional: Quality gates
      min-coverage: '80'
      fail-on-vulnerabilities: true
```

## Language-Specific Examples

### Node.js/React

```yaml
jobs:
  pipeline:
    uses: susanavenda/devops-toolkit/.github/workflows/golden-pipeline.yml@main
    with:
      language: nodejs
      runtime-version: '20'
      install-command: 'npm ci'
      build-command: 'npm run build'
      test-command: 'npm test'
      lint-command: 'npm run lint'
      build-artifacts-path: 'dist'
      coverage-path: 'coverage/lcov.info'
```

### Java/Spring Boot

```yaml
jobs:
  pipeline:
    uses: susanavenda/devops-toolkit/.github/workflows/golden-pipeline.yml@main
    with:
      language: java
      runtime-version: '21'
      install-command: 'mvn -B dependency:resolve'
      build-command: 'mvn -B clean package'
      test-command: 'mvn -B test'
      lint-command: 'mvn -B checkstyle:check'
      build-artifacts-path: 'target/*.jar'
      coverage-path: 'target/site/jacoco/jacoco.xml'
```

### Python

```yaml
jobs:
  pipeline:
    uses: susanavenda/devops-toolkit/.github/workflows/golden-pipeline.yml@main
    with:
      language: python
      runtime-version: '3.11'
      install-command: 'pip install -r requirements.txt'
      build-command: 'python setup.py build'
      test-command: 'pytest'
      lint-command: 'flake8 .'
      format-command: 'black --check .'
      coverage-path: 'coverage.xml'
```

### Go

```yaml
jobs:
  pipeline:
    uses: susanavenda/devops-toolkit/.github/workflows/golden-pipeline.yml@main
    with:
      language: go
      runtime-version: '1.21'
      install-command: 'go mod download'
      build-command: 'go build ./...'
      test-command: 'go test ./...'
      lint-command: 'golangci-lint run'
      build-artifacts-path: 'bin'
```

## Best Practices

### 1. Always Specify Language
The `language` input is required and determines which runtime environment is set up.

### 2. Provide All Build Commands
Even if optional, providing all commands ensures consistent behavior:
- `install-command`: Install dependencies
- `build-command`: Build the application
- `test-command`: Run tests
- `lint-command`: Run linting
- `format-command`: Check formatting

### 3. Configure Artifact Paths
Specify where build outputs and coverage reports are located:
- `build-artifacts-path`: Where build artifacts are created
- `coverage-path`: Path to coverage reports

### 4. Enable Security Scanning
By default, all security scans are enabled. Disable only if necessary:
- `enable-sast`: Static Application Security Testing
- `enable-dependency-scan`: Dependency vulnerability scanning
- `enable-secrets-scan`: Secrets detection
- `enable-container-scan`: Container security scanning
- `enable-infrastructure-scan`: Infrastructure as Code scanning

### 5. Set Quality Gates
Configure minimum quality thresholds:
- `min-coverage`: Minimum code coverage percentage
- `fail-on-vulnerabilities`: Fail pipeline on critical vulnerabilities

## Pipeline Stages

The Golden Pipeline interface guarantees these stages:

1. **Code Quality & Security** - Linting, SAST, dependency scanning, secrets detection
2. **Build & Test** - Build application, run tests, generate coverage
3. **Container Security** - Scan container images (if Dockerfile exists)
4. **Infrastructure Security** - Scan IaC (if Terraform files exist)
5. **Security Summary** - Consolidated security report

## Benefits of Interface Pattern

### Consistency
- All projects follow the same pipeline structure
- Predictable behavior across projects
- Easy to understand and maintain

### Flexibility
- Language-agnostic design
- Configurable security scanning
- Customizable quality gates

### Maintainability
- Single source of truth for pipeline logic
- Updates propagate to all projects
- Reduced duplication

### Security
- Security-first approach by default
- Multiple layers of defense
- Comprehensive scanning

## Migration Guide

### From Language-Specific Pipelines

If you're currently using language-specific pipelines (`golden-pipeline-nodejs.yml`, `golden-pipeline-java.yml`), migrate to the unified interface:

**Before:**
```yaml
jobs:
  pipeline:
    uses: susanavenda/devops-toolkit/.github/workflows/golden-pipeline-nodejs.yml@main
```

**After:**
```yaml
jobs:
  pipeline:
    uses: susanavenda/devops-toolkit/.github/workflows/golden-pipeline.yml@main
    with:
      language: nodejs
      # ... other configuration
```

## Compliance

Projects implementing the Golden Pipeline interface automatically comply with:

- ✅ DevSecOps best practices
- ✅ Security scanning requirements
- ✅ Code quality standards
- ✅ Infrastructure security standards
- ✅ CI/CD best practices

## Support

For questions or issues:
- See [DevSecOps Pipeline Guide](devsecops-pipeline.md)
- Check [Project Integration Guide](../PROJECT_INTEGRATION.md)
- Review workflow examples in `devops-toolkit/.github/workflows/`
