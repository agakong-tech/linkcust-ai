#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-}"
ROOT_DIR="/opt/linkcust"
COMPOSE_FILE="$ROOT_DIR/deploy/compose/docker-compose.yml"
ENV_FILE="$ROOT_DIR/.env"
STATE_DIR="$ROOT_DIR/.deploy-state"

if [[ "$ENVIRONMENT" != "test" && "$ENVIRONMENT" != "production" ]]; then
  echo "usage: $0 <test|production>" >&2
  exit 2
fi

: "${IMAGE_TAG:?IMAGE_TAG must be supplied by CI}"
: "${HARBOR_REGISTRY:?HARBOR_REGISTRY must be supplied by CI or shell}"

mkdir -p "$STATE_DIR"

if [[ -f "$STATE_DIR/current-image-tag" ]]; then
  cp "$STATE_DIR/current-image-tag" "$STATE_DIR/previous-image-tag"
fi
printf '%s\n' "$IMAGE_TAG" > "$STATE_DIR/pending-image-tag"

export IMAGE_TAG HARBOR_REGISTRY

docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" pull
docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" up -d --remove-orphans

if "$ROOT_DIR/deploy/scripts/health-check.sh"; then
  mv "$STATE_DIR/pending-image-tag" "$STATE_DIR/current-image-tag"
  echo "deployed $ENVIRONMENT: $IMAGE_TAG"
else
  echo "health check failed; attempting rollback" >&2
  "$ROOT_DIR/deploy/scripts/rollback.sh"
  exit 1
fi
