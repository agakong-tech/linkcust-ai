#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="/opt/linkcust"
COMPOSE_FILE="$ROOT_DIR/deploy/compose/docker-compose.yml"
ENV_FILE="$ROOT_DIR/.env"
STATE_DIR="$ROOT_DIR/.deploy-state"
PREVIOUS_TAG_FILE="$STATE_DIR/previous-image-tag"

if [[ ! -s "$PREVIOUS_TAG_FILE" ]]; then
  echo "no previous image tag is recorded; automatic rollback is unavailable" >&2
  exit 1
fi

IMAGE_TAG="$(cat "$PREVIOUS_TAG_FILE")"
export IMAGE_TAG

docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" pull
docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" up -d --remove-orphans
printf '%s\n' "$IMAGE_TAG" > "$STATE_DIR/current-image-tag"

echo "rolled back to $IMAGE_TAG"
