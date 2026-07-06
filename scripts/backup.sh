#!/usr/bin/env bash
# Creates a timestamped pg_dump of the local database defined in
# docker-compose.yml and stores it under ./backups.
set -euo pipefail

CONTAINER_NAME="hotel_booking_db"
DB_USER="app_user"
DB_NAME="hotel_booking"
BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/backups"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql"

mkdir -p "${BACKUP_DIR}"

echo "Backing up ${DB_NAME} from container ${CONTAINER_NAME} to ${BACKUP_FILE} ..."

docker exec -t "${CONTAINER_NAME}" pg_dump -U "${DB_USER}" -d "${DB_NAME}" > "${BACKUP_FILE}"

echo "Backup complete: ${BACKUP_FILE}"
