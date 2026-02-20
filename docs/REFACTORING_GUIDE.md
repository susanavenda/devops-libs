# Refactoring Guide

## Overview

This guide provides step-by-step instructions for refactoring projects to follow standardized patterns and best practices.

## Quick Start

### 1. Standardize Configuration Files

Copy standard configuration files from `devops-libs/templates/`:

```bash
# For Node.js projects
cp devops-libs/templates/.gitignore-nodejs .gitignore
cp devops-libs/templates/.nvmrc .
cp devops-libs/templates/.prettierrc.json .
cp devops-libs/templates/.prettierignore .
cp devops-libs/templates/.eslintrc.json .

# For Java projects
cp devops-libs/templates/.gitignore-java .gitignore
cp devops-libs/templates/.java-version .
```

### 2. Standardize Project Structure

Ensure all projects follow the standard structure:

```
project-name/
├── .github/workflows/  # CI/CD workflows
├── config/             # Configuration files
├── docs/               # Documentation
├── infrastructure/     # Infrastructure as Code
├── scripts/            # Utility scripts
├── src/                # Source code
├── tests/              # Test files
├── .editorconfig       # Editor configuration
├── .gitignore          # Git ignore rules
├── CHANGELOG.md        # Change log
└── README.md           # Project documentation
```

### 3. Update package.json / pom.xml

Standardize metadata and scripts:

**package.json:**
```json
{
  "name": "project-name",
  "version": "1.0.0",
  "private": true,
  "description": "...",
  "author": "Susana Venda",
  "license": "UNLICENSED",
  "keywords": ["keyword1", "keyword2"],
  "scripts": {
    "dev": "...",
    "build": "...",
    "test": "...",
    "test:coverage": "...",
    "lint": "...",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "clean": "rm -rf dist build"
  }
}
```

### 4. Standardize Workflows

Use the Golden Pipeline interface:

```yaml
jobs:
  pipeline:
    uses: susanavenda/devops-libs/.github/workflows/golden-pipeline.yml@main
    with:
      language: nodejs
      # ... configuration
```

## Refactoring Checklist

### Configuration Files
- [ ] `.gitignore` exists and is standardized
- [ ] `.editorconfig` exists
- [ ] `.nvmrc` or `.java-version` exists
- [ ] `.prettierrc.json` exists (Node.js projects)
- [ ] `.eslintrc.json` exists (Node.js projects)

### Project Structure
- [ ] Standard directory structure
- [ ] Consistent naming conventions
- [ ] No duplicate files/directories

### Documentation
- [ ] README.md follows template
- [ ] CHANGELOG.md exists
- [ ] Infrastructure README exists

### Code Quality
- [ ] Linting configured
- [ ] Formatting configured
- [ ] Tests configured
- [ ] Coverage reporting configured

### CI/CD
- [ ] Uses Golden Pipeline interface
- [ ] Infrastructure security scan configured
- [ ] Release workflow exists

## Common Refactoring Tasks

### Remove Duplicate Files

```bash
# Identify duplicates
find . -name "*.json" -type f | sort | uniq -d

# Remove duplicates (be careful!)
# Keep files in appropriate locations
```

### Standardize Scripts

```bash
# Add standard scripts to package.json
npm pkg set scripts.format="prettier --write ."
npm pkg set scripts.format:check="prettier --check ."
npm pkg set scripts.test:coverage="..."
```

### Clean Up Structure

```bash
# Move files to standard locations
# Remove unnecessary directories
# Consolidate duplicate content
```

## Best Practices

1. **Start Small:** Refactor one project at a time
2. **Test Changes:** Ensure refactoring doesn't break functionality
3. **Document Changes:** Update CHANGELOG.md
4. **Commit Incrementally:** Small, focused commits
5. **Review:** Have changes reviewed before merging

## Troubleshooting

### Common Issues

1. **Missing Dependencies:** Add missing dev dependencies
2. **Broken Scripts:** Update scripts to match new structure
3. **Linting Errors:** Fix linting issues incrementally
4. **Test Failures:** Update tests to match refactored code

## References

- [Refactoring Opportunities](../REFACTORING_OPPORTUNITIES.md)
- [Pipeline Interface](pipeline-interface.md)
- [Conventions](../.github/CONVENTIONS.md)
