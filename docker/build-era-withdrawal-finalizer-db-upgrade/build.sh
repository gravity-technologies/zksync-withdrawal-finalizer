#!/usr/bin/env bash
#
# Build the era-withdrawal-finalizer-db-upgrade image for the target runtime
# platform. Build context is the repo root (migrations live in
# ./storage/migrations relative to it).
# Usage: ./build.sh <version>   (e.g. v0.9.4)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

VERSION="${1:?usage: ./build.sh <version>  (e.g. v0.9.4)}"
IMAGE_NAME="${IMAGE_NAME:-era-withdrawal-finalizer-db-upgrade}"
PLATFORM="${PLATFORM:-linux/amd64}"

cd "$REPO_ROOT"

if docker buildx version >/dev/null 2>&1; then
    docker buildx build --platform "$PLATFORM" --load \
        -f "$SCRIPT_DIR/Dockerfile" \
        -t "${IMAGE_NAME}:${VERSION}" .
else
    cat >&2 <<EOF
Docker Buildx is not installed or is not visible to the Docker CLI.

This image must be built for ${PLATFORM}; otherwise an ARM Mac can publish an
image that fails on AMD64 GCP nodes with:

  exec /app/entrypoint.sh: exec format error

Install Docker Buildx, then rerun:

  ./build.sh ${VERSION}
EOF
    exit 1
fi

echo ">> Built ${IMAGE_NAME}:${VERSION} for ${PLATFORM}"
