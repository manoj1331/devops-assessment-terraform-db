#!/usr/bin/env bash
# Restores a backup produced by scripts/backup.sh into a fresh local
# database. Usage: ./scripts/restore.sh path/to/backup_file.sql
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <path-to-backup-file.sql>"
  exit 1
fi

BACKUP_FILE="$1"
CONTAINER_NAME="hotel_booking_db"
DB_USER="app_user"
DB_NAME="hotel_booking"
RESTORE_DB_NAME="${DB_NAME}_restore_test"

if [[ ! -f "${BACKUP_FILE}" ]]; then
  echo "Backup file not found: ${BACKUP_FILE}"
  exit 1
fi

echo "Creating fresh database ${RESTORE_DB_NAME} ..."
docker exec -t "${CONTAINER_NAME}" psql -U "${DB_USER}" -d postgres \
  -c "DROP DATABASE IF EXISTS ${RESTORE_DB_NAME};"
docker exec -t "${CONTAINER_NAME}" psql -U "${DB_USER}" -d postgres \
  -c "CREATE DATABASE ${RESTORE_DB_NAME};"

echo "Restoring ${BACKUP_FILE} into ${RESTORE_DB_NAME} ..."
docker exec -i "${CONTAINER_NAME}" psql -U "${DB_USER}" -d "${RESTORE_DB_NAME}" < "${BACKUP_FILE}"

echo "Restore complete."
echo "Verify with:"
echo "  docker exec -it ${CONTAINER_NAME} psql -U ${DB_USER} -d ${RESTORE_DB_NAME} -c '\\dt'"
echo "  docker exec -it ${CONTAINER_NAME} psql -U ${DB_USER} -d ${RESTORE_DB_NAME} -c 'SELECT COUNT(*) FROM hotel_bookings;'"
