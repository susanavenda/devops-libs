#!/bin/bash

# Read project configuration and output as environment variables
# Usage: source scripts/read-config.sh

CONFIG_FILE="${1:-config/project-config.yml}"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "⚠️  Config file not found: $CONFIG_FILE"
  return 1
fi

# Simple YAML parser (basic implementation)
# For production, use yq or similar tool
read_yaml() {
  local file="$1"
  local prefix="$2"
  
  while IFS= read -r line; do
    # Skip comments and empty lines
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// }" ]] && continue
    
    # Parse key: value pairs
    if [[ "$line" =~ ^[[:space:]]*([^:]+):[[:space:]]*(.+)$ ]]; then
      local key="${BASH_REMATCH[1]// /}"
      local value="${BASH_REMATCH[2]// /}"
      
      # Remove quotes
      value="${value#\"}"
      value="${value%\"}"
      value="${value#\'}"
      value="${value%\'}"
      
      # Handle environment variable substitution
      if [[ "$value" =~ \$\{([^}]+)\} ]]; then
        local env_var="${BASH_REMATCH[1]}"
        local default_value=""
        if [[ "$env_var" =~ ^([^:-]+):-([^}]+)$ ]]; then
          env_var="${BASH_REMATCH[1]}"
          default_value="${BASH_REMATCH[2]}"
        fi
        value="${!env_var:-$default_value}"
      fi
      
      # Export as environment variable
      local var_name="${prefix}${key^^}"
      var_name="${var_name//-/_}"
      export "$var_name=$value"
    fi
  done < "$file"
}

# Read configuration
read_yaml "$CONFIG_FILE" "CONFIG_"

echo "✅ Configuration loaded from $CONFIG_FILE"
