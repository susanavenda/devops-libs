# Pipeline Conventions & Best Practices

## Golden Pipeline Interface

All projects **MUST** implement the Golden Pipeline interface. This ensures consistency, security, and maintainability across all repositories.

## Implementation Requirements

### Required Configuration

Every project workflow **MUST** include:

```yaml
jobs:
  pipeline:
    uses: susanavenda/devops-libs/.github/workflows/golden-pipeline.yml@main
    with:
      language: <nodejs|java|python|go|dotnet>
      install-command: '<command>'
      build-command: '<command>'
      test-command: '<command>'
```

### Standard Workflow Structure

All projects **SHOULD** follow this structure:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  # Main pipeline - REQUIRED
  pipeline:
    uses: susanavenda/devops-libs/.github/workflows/golden-pipeline.yml@main
    with:
      # ... configuration

  # Infrastructure security - REQUIRED if infrastructure/ exists
  infrastructure-security:
    if: hashFiles('infrastructure/**/*.tf') != ''
    uses: susanavenda/devops-libs/.github/workflows/infrastructure-security.yml@main
    with:
      working-directory: 'infrastructure'
```

## Naming Conventions

### Workflow Files
- **CI workflow:** `ci.yml` (required)
- **Deployment workflow:** `deploy.yml` (optional)
- **Release workflow:** `release.yml` (optional)

### Workflow Names
- Use descriptive names: `CI`, `Deploy`, `Release`
- Avoid generic names: `main`, `build`, `test`

## Security Requirements

### Required Security Scans
All projects **MUST** enable:
- ✅ SAST scanning (CodeQL)
- ✅ Dependency scanning (OWASP Dependency Check)
- ✅ Secrets scanning (TruffleHog)

### Optional Security Scans
Projects **SHOULD** enable if applicable:
- Container scanning (if Dockerfile exists)
- Infrastructure scanning (if Terraform files exist)

## Quality Gates

### Minimum Requirements
- All tests must pass
- No critical vulnerabilities
- Code must be linted (if linting configured)

### Recommended
- Minimum 80% code coverage
- No high-severity vulnerabilities
- All code formatted consistently

## Branch Strategy

### Default Branch
- **MUST** be `main` (not `master`)
- **MUST** be protected
- **SHOULD** require PR reviews

### Branch Naming
- Feature branches: `feature/description`
- Bug fixes: `fix/description`
- Hotfixes: `hotfix/description`
- Releases: `release/vX.Y.Z`

## Version Management

### Versioning
- **MUST** use Semantic Versioning (SemVer)
- **MUST** maintain CHANGELOG.md
- **SHOULD** tag releases with `vX.Y.Z`

### Release Process
1. Update CHANGELOG.md
2. Update version in package.json/pom.xml
3. Commit changes
4. Create and push tag: `git tag vX.Y.Z && git push origin vX.Y.Z`
5. GitHub Actions automatically creates release

## Project Structure

### Required Directories
```
project-name/
├── .github/workflows/     # CI/CD workflows
├── infrastructure/         # Infrastructure as Code (if applicable)
├── src/                   # Source code
└── README.md              # Project documentation
```

### Required Files
- `README.md` - Project documentation
- `CHANGELOG.md` - Version history
- `.github/workflows/ci.yml` - CI workflow
- `.gitignore` - Git ignore rules

## Documentation Standards

### README.md
**MUST** include:
- Project overview
- Getting started guide
- Tech stack
- Project structure
- License

**SHOULD** include:
- API documentation
- Contributing guidelines
- Deployment instructions

### CHANGELOG.md
**MUST** follow [Keep a Changelog](https://keepachangelog.com/) format:
```markdown
## [Unreleased]

## [1.0.0] - YYYY-MM-DD

### Added
- Feature description

### Changed
- Change description

### Fixed
- Bug fix description
```

## Code Quality

### Linting
- **MUST** configure linting for the primary language
- **SHOULD** fail build on linting errors
- **SHOULD** use project-specific linting rules

### Formatting
- **SHOULD** enforce consistent code formatting
- **SHOULD** use automated formatting tools
- **SHOULD** check formatting in CI

### Testing
- **MUST** have test suite
- **SHOULD** maintain minimum code coverage
- **SHOULD** run tests in CI pipeline

## Security Best Practices

### Secrets Management
- **MUST NOT** commit secrets to repository
- **MUST** use GitHub Secrets for sensitive data
- **SHOULD** rotate secrets regularly

### Dependency Management
- **MUST** keep dependencies up to date
- **SHOULD** use dependency scanning
- **SHOULD** review security advisories

### Container Security
- **MUST** scan container images
- **SHOULD** use minimal base images
- **SHOULD** run containers as non-root

## Compliance Checklist

Projects **MUST** comply with:

- [ ] Uses Golden Pipeline interface
- [ ] Has `main` as default branch
- [ ] Has `ci.yml` workflow
- [ ] Has `CHANGELOG.md`
- [ ] Has `README.md`
- [ ] Security scanning enabled
- [ ] Infrastructure security scanning (if applicable)
- [ ] Version tags follow SemVer
- [ ] Code is linted and formatted
- [ ] Tests are configured and passing

## Enforcement

### Automated Checks
- GitHub Actions workflows enforce conventions
- Security scans run automatically
- Quality gates prevent merging non-compliant code

### Manual Review
- PR reviews check compliance
- Documentation reviews ensure standards
- Architecture reviews validate structure

## Exceptions

Exceptions to conventions **MUST** be:
- Documented in project README
- Approved by maintainers
- Justified with technical reasoning

## Updates

Conventions are updated through:
- `devops-libs` repository
- Pull request process
- Team consensus
- Documentation updates

## References

- [Golden Pipeline Interface](docs/pipeline-interface.md)
- [DevSecOps Pipeline Guide](docs/devsecops-pipeline.md)
- [Project Integration Guide](PROJECT_INTEGRATION.md)
