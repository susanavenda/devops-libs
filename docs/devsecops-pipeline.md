# DevSecOps Golden Pipeline Documentation

## Overview

The DevSecOps Golden Pipeline is a comprehensive, standardized CI/CD pipeline that integrates security throughout the software development lifecycle. It follows security-first principles and implements multiple layers of security scanning and quality gates.

## Pipeline Stages

### Stage 1: Code Quality & Security Scanning

**Purpose:** Identify security vulnerabilities and code quality issues early in the development process.

**Tools & Checks:**
- **SAST (Static Application Security Testing):**
  - CodeQL (GitHub native)
  - SonarQube (optional, if token provided)
  
- **Code Quality:**
  - ESLint / Checkstyle
  - Code formatting checks
  - SpotBugs (Java)
  
- **Dependency Scanning:**
  - npm audit / Maven dependency check
  - OWASP Dependency Check
  - Snyk (optional)
  
- **Secrets Scanning:**
  - TruffleHog
  - Gitleaks
  
- **License Compliance:**
  - Automated license checking

### Stage 2: Build & Test

**Purpose:** Build the application and run tests with coverage reporting.

**Activities:**
- Install dependencies
- Run unit tests
- Run integration tests
- Build application
- Generate code coverage reports
- Upload coverage to Codecov

**Quality Gates:**
- All tests must pass
- Minimum code coverage thresholds (configurable)

### Stage 3: Container Security

**Purpose:** Scan container images for vulnerabilities.

**Tools:**
- **Trivy:** Comprehensive vulnerability scanner
- **Docker Scout:** Docker-native security scanning

**Scans:**
- Base image vulnerabilities
- Package vulnerabilities
- Configuration issues
- Best practices violations

### Stage 4: Infrastructure Security

**Purpose:** Scan Infrastructure as Code for security misconfigurations.

**Tools:**
- **Checkov:** Comprehensive IaC security scanning
- **Terrascan:** Policy as Code scanning
- **TFLint:** Terraform linting and validation

**Scans:**
- Security misconfigurations
- Compliance violations
- Best practices
- Terraform validation

### Stage 5: Security Summary

**Purpose:** Provide a consolidated view of all security scans.

**Output:**
- Summary of all security checks
- Links to detailed reports
- Actionable recommendations

## Usage

### Node.js Projects

```yaml
jobs:
  pipeline:
    uses: susanavenda/devops-toolkit/.github/workflows/golden-pipeline-nodejs.yml@main
    with:
      node-version: '20'
      install-command: 'npm ci'
      build-command: 'npm run build'
      test-command: 'npm test'
      lint-command: 'npm run lint'
```

### Java Projects

```yaml
jobs:
  pipeline:
    uses: susanavenda/devops-toolkit/.github/workflows/golden-pipeline-java.yml@main
    with:
      java-version: '21'
      distribution: 'temurin'
      build-command: 'mvn -B clean package'
      test-command: 'mvn -B test'
```

### Infrastructure Security

```yaml
jobs:
  infrastructure-security:
    uses: susanavenda/devops-toolkit/.github/workflows/infrastructure-security.yml@main
    with:
      terraform-version: '1.6.0'
      working-directory: 'infrastructure'
```

### Standalone Security Scan

```yaml
jobs:
  security-scan:
    uses: susanavenda/devops-toolkit/.github/workflows/security-scan.yml@main
    with:
      scan-type: 'all'  # Options: all, secrets, dependencies, containers, infrastructure
```

## Security Tools

### SAST (Static Application Security Testing)

- **CodeQL:** GitHub's semantic code analysis engine
- **SonarQube:** Comprehensive code quality and security analysis
- **ESLint Security Plugin:** JavaScript/TypeScript security rules
- **SpotBugs:** Java static analysis

### Dependency Scanning

- **OWASP Dependency Check:** Identifies known vulnerabilities
- **npm audit:** Node.js dependency vulnerability scanning
- **Maven Dependency Plugin:** Java dependency analysis
- **Snyk:** Commercial dependency scanning (optional)

### Secrets Scanning

- **TruffleHog:** Detects secrets and credentials
- **Gitleaks:** Fast secrets scanning
- **GitHub Secret Scanning:** Native GitHub feature

### Container Security

- **Trivy:** Comprehensive container vulnerability scanner
- **Docker Scout:** Docker-native security scanning
- **Snyk Container:** Container image scanning (optional)

### Infrastructure Security

- **Checkov:** Comprehensive IaC security scanning
- **Terrascan:** Policy as Code for cloud infrastructure
- **TFLint:** Terraform linting and validation

## Security Gates

### Critical Vulnerabilities
- **Action:** Block deployment
- **Severity:** CRITICAL
- **Examples:** Remote code execution, SQL injection

### High Vulnerabilities
- **Action:** Warn, allow deployment with approval
- **Severity:** HIGH
- **Examples:** Privilege escalation, data exposure

### Medium/Low Vulnerabilities
- **Action:** Report, allow deployment
- **Severity:** MEDIUM, LOW
- **Examples:** Information disclosure, best practice violations

## Best Practices

### 1. Shift Left Security
- Run security scans early in the pipeline
- Fail fast on critical issues
- Provide immediate feedback to developers

### 2. Defense in Depth
- Multiple layers of security scanning
- Different tools for different purposes
- Comprehensive coverage

### 3. Continuous Monitoring
- Regular dependency updates
- Continuous security scanning
- Automated vulnerability detection

### 4. Security as Code
- Infrastructure security scanning
- Policy as Code
- Automated compliance checking

### 5. Developer Experience
- Clear error messages
- Actionable recommendations
- Fast feedback loops

## Configuration

### Required Secrets

- `SONAR_TOKEN`: SonarQube authentication token (optional)
- `SNYK_TOKEN`: Snyk authentication token (optional)
- `NPM_TOKEN`: NPM authentication token (for private packages)
- `MAVEN_SETTINGS`: Maven settings XML (for private repositories)

### Optional Configuration

- Code coverage thresholds
- Security scan severity levels
- Custom security policies
- Exclusion patterns

## Reporting

### GitHub Security Tab
- CodeQL results
- Dependency alerts
- Secret scanning alerts
- Dependabot alerts

### SARIF Uploads
- Trivy results
- Checkov results
- Terrascan results

### Code Coverage
- Codecov integration
- Coverage reports
- Coverage trends

## Troubleshooting

### Common Issues

1. **Secrets detected in code:**
   - Remove secrets from code
   - Use GitHub Secrets or environment variables
   - Rotate exposed credentials

2. **Dependency vulnerabilities:**
   - Update vulnerable dependencies
   - Use `npm audit fix` or `mvn versions:use-latest-versions`
   - Review and apply security patches

3. **Infrastructure misconfigurations:**
   - Review Checkov/Terrascan recommendations
   - Update Terraform configurations
   - Follow security best practices

4. **Code quality issues:**
   - Fix linting errors
   - Improve code coverage
   - Follow coding standards

## References

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [DevSecOps Principles](https://www.devsecops.org/)
- [Golden Pipeline Pattern](https://www.thoughtworks.com/insights/blog/golden-pipeline)
