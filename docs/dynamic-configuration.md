# Dynamic Configuration System

## Overview

All workflows and configurations have been refactored to be dynamic and configuration-driven, eliminating hardcoded values and static strings.

## Key Changes

### 1. Dynamic Branch Detection
**Before:**
```yaml
branches: [main]
```

**After:**
```yaml
branches: ['${{ github.event.repository.default_branch }}', 'develop']
```

### 2. Dynamic Repository References
**Before:**
```yaml
uses: susanavenda/devops-toolkit/.github/workflows/golden-pipeline.yml@main
```

**After:**
```yaml
env:
  DEVOPS_TOOLKIT_REPO: ${{ vars.DEVOPS_TOOLKIT_REPO || 'susanavenda/devops-toolkit' }}
  DEVOPS_TOOLKIT_BRANCH: ${{ vars.DEVOPS_TOOLKIT_BRANCH || 'main' }}
uses: ${{ env.DEVOPS_TOOLKIT_REPO }}/.github/workflows/golden-pipeline.yml@${{ env.DEVOPS_TOOLKIT_BRANCH }}
```

### 3. Automatic Project Detection
**Before:**
```yaml
language: nodejs
runtime-version: '20'
install-command: 'npm ci'
build-command: 'npm run build'
```

**After:**
```yaml
jobs:
  detect-config:
    name: Detect Project Configuration
    outputs:
      language: ${{ steps.detect.outputs.language }}
      runtime-version: ${{ steps.detect.outputs.runtime-version }}
      # ... automatically detected from package.json, pom.xml, etc.
```

### 4. Configuration Files
Projects can now use `config/project-config.yml` for explicit configuration:

```yaml
language:
  type: nodejs
  runtime-version: 20

build:
  install-command: npm ci
  build-command: npm run build
  test-command: npm test
```

### 5. Environment Variables
All hardcoded values can be overridden via GitHub Variables:

- `DEVOPS_TOOLKIT_REPO` - Custom DevOps toolkit repository
- `DEVOPS_TOOLKIT_BRANCH` - Custom DevOps toolkit branch
- `TERRAFORM_VERSION` - Terraform version
- `INFRASTRUCTURE_PATH` - Infrastructure directory path
- `ENABLE_SAST`, `ENABLE_DEPENDENCY_SCAN`, etc. - Security feature toggles
- `DEFAULT_NODE_VERSION`, `DEFAULT_JAVA_VERSION`, etc. - Runtime defaults

## Benefits

### 1. Flexibility
- Easy to change configurations without editing workflows
- Support for multiple branches (main, develop, etc.)
- Customizable via GitHub Variables

### 2. Maintainability
- Single source of truth (config files)
- Automatic detection reduces manual configuration
- Less duplication across projects

### 3. Scalability
- Easy to add new projects
- Consistent patterns across all repositories
- Configuration-driven approach

### 4. Portability
- Works with any repository name
- Adapts to different branch structures
- Environment-aware

## Usage

### Automatic Detection
Workflows automatically detect:
- Language from `package.json`, `pom.xml`, `go.mod`, etc.
- Runtime version from `.nvmrc`, `.java-version`, etc.
- Build commands from `package.json` scripts or `pom.xml` plugins

### Manual Configuration
Create `config/project-config.yml`:

```yaml
language:
  type: nodejs
  runtime-version: 20

build:
  install-command: npm ci
  build-command: npm run build
  test-command: npm test
```

### GitHub Variables
Set repository-level variables in GitHub Settings:
- Repository → Settings → Secrets and variables → Actions → Variables

## Scripts

### Generate Configuration
```bash
bash devops-toolkit/scripts/generate-workflow-config.sh /path/to/project
```

Generates `config/project-config.yml` based on project files.

### Read Configuration
```bash
source devops-toolkit/scripts/read-config.sh
```

Loads configuration as environment variables.

## Migration Guide

### For Existing Projects

1. **Update CI workflow:**
   - Replace hardcoded branches with `${{ github.event.repository.default_branch }}`
   - Add `detect-config` job
   - Use dynamic repository references

2. **Generate config (optional):**
   ```bash
   bash devops-toolkit/scripts/generate-workflow-config.sh .
   ```

3. **Set GitHub Variables (optional):**
   - Configure custom values in repository settings

### For New Projects

1. Copy dynamic CI workflow template
2. Configuration will be auto-detected
3. Optionally create `config/project-config.yml` for explicit values

## Examples

### Node.js Project
```yaml
# Auto-detected from package.json and .nvmrc
language: nodejs
runtime-version: 20
install-command: npm ci
build-command: npm run build
```

### Java Project
```yaml
# Auto-detected from pom.xml and .java-version
language: java
runtime-version: 21
install-command: mvn -B dependency:resolve
build-command: mvn -B clean package
```

## Best Practices

1. **Use GitHub Variables** for organization-wide defaults
2. **Create config files** for project-specific overrides
3. **Let auto-detection work** - only configure when needed
4. **Document custom configurations** in project README
5. **Version control config files** - commit `config/project-config.yml`

## Future Enhancements

- [ ] Support for multi-language projects
- [ ] Configuration validation
- [ ] Config file schema
- [ ] Migration tool for existing projects
- [ ] Configuration templates by project type
