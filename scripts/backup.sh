#!/bin/bash
# Generic backup script for databases and volumes
# Usage: ./backup.sh [backup-type] [destination]

set -e

BACKUP_TYPE=${1:-database}
DESTINATION=${2:-./backups}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "💾 Starting backup: $BACKUP_TYPE"

# Create backup directory
mkdir -p "$DESTINATION"

case $BACKUP_TYPE in
    database)
        echo "📊 Backing up database..."
        # PostgreSQL example
        if [ -n "$POSTGRES_HOST" ]; then
            BACKUP_FILE="$DESTINATION/postgres_${TIMESTAMP}.sql.gz"
            PGPASSWORD=$POSTGRES_PASSWORD pg_dump -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DB | gzip > "$BACKUP_FILE"
            echo "✅ Database backup saved to: $BACKUP_FILE"
        else
            echo "❌ PostgreSQL environment variables not set"
            exit 1
        fi
        ;;
    volume)
        echo "📦 Backing up volume..."
        VOLUME_NAME=${VOLUME_NAME:-data}
        BACKUP_FILE="$DESTINATION/volume_${VOLUME_NAME}_${TIMESTAMP}.tar.gz"
        if [ -d "/data/$VOLUME_NAME" ]; then
            tar -czf "$BACKUP_FILE" -C /data "$VOLUME_NAME"
            echo "✅ Volume backup saved to: $BACKUP_FILE"
        else
            echo "❌ Volume not found: /data/$VOLUME_NAME"
            exit 1
        fi
        ;;
    *)
        echo "❌ Unknown backup type: $BACKUP_TYPE"
        echo "Valid types: database, volume"
        exit 1
        ;;
esac

# Cleanup old backups (keep last 7 days)
echo "🧹 Cleaning up old backups..."
find "$DESTINATION" -type f -mtime +7 -delete

echo "🎉 Backup completed successfully!"
