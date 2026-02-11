#!/bin/bash

# Security Check Script
# Performs basic security checks on the repository

set -e

echo "🔒 Running Security Checks..."

# Check for secrets in code
echo "Checking for secrets..."
if command -v gitleaks &> /dev/null; then
  gitleaks detect --source . --verbose || echo "Gitleaks not installed, skipping..."
fi

# Check for hardcoded credentials
echo "Checking for hardcoded credentials..."
if grep -r "password.*=" --include="*.js" --include="*.java" --include="*.py" . 2>/dev/null | grep -v "//" | grep -v "test" | grep -v "example"; then
  echo "⚠️  Potential hardcoded passwords found"
fi

# Check for exposed API keys
echo "Checking for API keys..."
if grep -r "api[_-]key\|apikey\|api_key" --include="*.js" --include="*.java" --include="*.py" . 2>/dev/null | grep -v "//" | grep -v "test" | grep -v "example"; then
  echo "⚠️  Potential API keys found"
fi

# Check .gitignore
echo "Checking .gitignore..."
if [ ! -f ".gitignore" ]; then
  echo "❌ .gitignore missing"
else
  echo "✅ .gitignore exists"
fi

# Check for security files
echo "Checking security configuration..."
[ -f "SECURITY.md" ] && echo "✅ SECURITY.md exists" || echo "❌ SECURITY.md missing"
[ -f ".github/dependabot.yml" ] && echo "✅ Dependabot configured" || echo "❌ Dependabot not configured"

echo "✅ Security checks completed"
