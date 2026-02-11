#!/bin/bash

# Generate workflow configuration from project files
# Reads package.json, pom.xml, .nvmrc, .java-version, etc. to create dynamic config

set -e

PROJECT_DIR="${1:-.}"
CONFIG_FILE="${PROJECT_DIR}/config/project-config.yml"

# Detect project type and extract values
detect_project_config() {
  local project_dir="$1"
  local config_file="$2"
  
  echo "# Auto-generated project configuration" > "$config_file"
  echo "# Generated: $(date -u +'%Y-%m-%d %H:%M:%S UTC')" >> "$config_file"
  echo "" >> "$config_file"
  
  # Detect language and runtime version
  if [ -f "${project_dir}/package.json" ]; then
    LANGUAGE_TYPE="nodejs"
    RUNTIME_VERSION=$(cat "${project_dir}/.nvmrc" 2>/dev/null || echo "20")
    INSTALL_COMMAND="npm ci"
    BUILD_COMMAND=$(node -e "console.log(require('./package.json').scripts.build || 'npm run build')" 2>/dev/null || echo "npm run build")
    TEST_COMMAND=$(node -e "console.log(require('./package.json').scripts.test || 'npm test')" 2>/dev/null || echo "npm test")
    LINT_COMMAND=$(node -e "console.log(require('./package.json').scripts.lint || 'npm run lint')" 2>/dev/null || echo "npm run lint")
    BUILD_ARTIFACTS_PATH="dist"
    COVERAGE_PATH="coverage/lcov.info"
  elif [ -f "${project_dir}/pom.xml" ]; then
    LANGUAGE_TYPE="java"
    RUNTIME_VERSION=$(cat "${project_dir}/.java-version" 2>/dev/null || echo "21")
    INSTALL_COMMAND="mvn -B dependency:resolve"
    BUILD_COMMAND="mvn -B clean package"
    TEST_COMMAND="mvn -B test"
    LINT_COMMAND="mvn -B checkstyle:check"
    BUILD_ARTIFACTS_PATH="target/*.jar"
    COVERAGE_PATH="target/site/jacoco/jacoco.xml"
  elif [ -f "${project_dir}/requirements.txt" ] || [ -f "${project_dir}/pyproject.toml" ]; then
    LANGUAGE_TYPE="python"
    RUNTIME_VERSION="3.11"
    INSTALL_COMMAND="pip install -r requirements.txt"
    BUILD_COMMAND="python setup.py build"
    TEST_COMMAND="pytest"
    LINT_COMMAND="pylint ."
    BUILD_ARTIFACTS_PATH="dist"
    COVERAGE_PATH="coverage.xml"
  elif [ -f "${project_dir}/go.mod" ]; then
    LANGUAGE_TYPE="go"
    RUNTIME_VERSION="1.21"
    INSTALL_COMMAND="go mod download"
    BUILD_COMMAND="go build ./..."
    TEST_COMMAND="go test ./..."
    LINT_COMMAND="golangci-lint run"
    BUILD_ARTIFACTS_PATH="bin"
    COVERAGE_PATH="coverage.out"
  elif [ -f "${project_dir}/*.csproj" ]; then
    LANGUAGE_TYPE="dotnet"
    RUNTIME_VERSION="8.0.x"
    INSTALL_COMMAND="dotnet restore"
    BUILD_COMMAND="dotnet build"
    TEST_COMMAND="dotnet test"
    LINT_COMMAND="dotnet format --verify-no-changes"
    BUILD_ARTIFACTS_PATH="bin"
    COVERAGE_PATH="coverage.xml"
  else
    LANGUAGE_TYPE="nodejs"
    RUNTIME_VERSION="20"
    INSTALL_COMMAND="npm ci"
    BUILD_COMMAND="npm run build"
    TEST_COMMAND="npm test"
    LINT_COMMAND="npm run lint"
    BUILD_ARTIFACTS_PATH="dist"
    COVERAGE_PATH="coverage/lcov.info"
  fi
  
  # Write config
  cat >> "$config_file" <<EOF
project:
  name: \${PROJECT_NAME}
  repository: \${GITHUB_REPOSITORY}
  default-branch: \${GITHUB_REF_NAME:-main}

language:
  type: ${LANGUAGE_TYPE}
  runtime-version: ${RUNTIME_VERSION}

build:
  install-command: ${INSTALL_COMMAND}
  build-command: ${BUILD_COMMAND}
  test-command: ${TEST_COMMAND}
  lint-command: ${LINT_COMMAND}
  format-command: \${FORMAT_COMMAND:-}

paths:
  working-directory: .
  build-artifacts: ${BUILD_ARTIFACTS_PATH}
  coverage: ${COVERAGE_PATH}

security:
  enable-sast: true
  enable-dependency-scan: true
  enable-secrets-scan: true
  enable-container-scan: true
  enable-infrastructure-scan: true
  fail-on-vulnerabilities: true

infrastructure:
  terraform-version: 1.6.0
  infrastructure-path: infrastructure

devops-toolkit:
  repository: susanavenda/devops-toolkit
  branch: main
EOF

  echo "✅ Generated configuration: $config_file"
  echo "   Language: $LANGUAGE_TYPE"
  echo "   Runtime: $RUNTIME_VERSION"
}

# Create config directory if it doesn't exist
mkdir -p "$(dirname "$CONFIG_FILE")"

# Generate config
detect_project_config "$PROJECT_DIR" "$CONFIG_FILE"
