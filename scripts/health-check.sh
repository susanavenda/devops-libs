#!/bin/bash
# Generic health check script
# Usage: ./health-check.sh [url]

set -e

URL=${1:-http://localhost:8080/health}
MAX_RETRIES=${MAX_RETRIES:-5}
RETRY_DELAY=${RETRY_DELAY:-5}

echo "🏥 Health check for: $URL"

for i in $(seq 1 $MAX_RETRIES); do
    echo "Attempt $i/$MAX_RETRIES..."
    
    if curl -f -s "$URL" > /dev/null; then
        echo "✅ Health check passed!"
        exit 0
    fi
    
    if [ $i -lt $MAX_RETRIES ]; then
        echo "⏳ Waiting ${RETRY_DELAY}s before retry..."
        sleep $RETRY_DELAY
    fi
done

echo "❌ Health check failed after $MAX_RETRIES attempts"
exit 1
