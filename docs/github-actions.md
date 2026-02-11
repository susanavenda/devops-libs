# GitHub Actions Guide

How to use reusable GitHub Actions workflows and composite actions from this toolkit.

## Reusable Workflows

### Node.js CI

For Node.js, React, or npm-based projects.

```yaml
jobs:
  build:
    uses: susanavenda/devops-toolkit/.github/workflows/nodejs-ci.yml@main
    with:
      node-version: '20'
      build-command: 'npm run build'
      test-command: 'npm test'
```

**Available Inputs:**
- `node-version`: Node.js version (default: '20')
- `install-command`: Installation command (default: 'npm ci')
- `build-command`: Build command (default: 'npm run build')
- `test-command`: Test command (default: 'npm test')
- `cache-key`: Cache key type (default: 'npm')
- `working-directory`: Working directory (default: '.')

### Java CI

For Java/Maven projects.

```yaml
jobs:
  build:
    uses: susanavenda/devops-toolkit/.github/workflows/java-ci.yml@main
    with:
      java-version: '21'
      build-command: 'mvn -B clean package'
```

### Docker Build

Build and push Docker images.

```yaml
jobs:
  build:
    uses: susanavenda/devops-toolkit/.github/workflows/docker-build.yml@main
    with:
      image-name: 'myapp'
      tags: 'latest'
    secrets:
      DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
      DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
```

### GitHub Pages Deploy

Deploy static sites to GitHub Pages.

```yaml
jobs:
  deploy:
    uses: susanavenda/devops-toolkit/.github/workflows/github-pages-deploy.yml@main
    with:
      build-command: 'npm run build'
      source-dir: 'dist'
      target-dir: 'docs'
    secrets:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Composite Actions

### Setup Node.js

```yaml
steps:
  - uses: susanavenda/devops-toolkit/.github/actions/setup-node@main
    with:
      node-version: '20'
      cache-key: 'npm'
```

### Docker Build

```yaml
steps:
  - uses: susanavenda/devops-toolkit/.github/actions/docker-build@main
    with:
      image-name: 'myapp'
      tags: 'latest'
```

## Best Practices

1. Pin versions: Use specific version tags (`@v1.0.0`) instead of `@main`
2. Use secrets: Never hardcode credentials
3. Customize inputs: Adjust inputs to match your project needs
4. Test locally: Use `act` or GitHub Actions locally before pushing

## Examples

See `examples/` directory for complete usage examples.
