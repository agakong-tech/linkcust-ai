#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="/opt/linkcust"
ENV_FILE="$ROOT_DIR/.env"

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

URL="${HEALTHCHECK_URL:-http://127.0.0.1:3000/healthz}"
RETRIES="${HEALTHCHECK_RETRIES:-30}"
INTERVAL="${HEALTHCHECK_INTERVAL_SECONDS:-5}"

for ((i=1; i<=RETRIES; i++)); do
  if curl --fail --silent --show-error --max-time 5 "$URL" >/dev/null; then
    echo "health check passed: $URL"
    exit 0
  fi
  sleep "$INTERVAL"
done

echo "health check failed after $RETRIES attempts: $URL" >&2
exit 1
