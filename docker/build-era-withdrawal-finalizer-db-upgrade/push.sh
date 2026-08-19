#!/usr/bin/env bash
#
# Push a locally built era-withdrawal-finalizer-db-upgrade image to the
# registry. Follows the same flat (no per-environment) path used by the
# era-withdrawal-finalizer app image itself.
set -euo pipefail

VERSION="${1:?usage: ./push.sh <version> [local-image]}"
LOCAL_IMAGE="${2:-era-withdrawal-finalizer-db-upgrade:${VERSION}}"
EXPECTED_PLATFORM="${EXPECTED_PLATFORM:-linux/amd64}"

REGISTRY="asia-northeast1-docker.pkg.dev/grvt-registry/images"
REMOTE="${REGISTRY}/era-withdrawal-finalizer-db-upgrade:${VERSION}"

LOCAL_PLATFORM="$(docker image inspect "$LOCAL_IMAGE" --format '{{.Os}}/{{.Architecture}}')"
if [ "$LOCAL_PLATFORM" != "$EXPECTED_PLATFORM" ]; then
    echo ">> Refusing to push $LOCAL_IMAGE: platform is $LOCAL_PLATFORM, expected $EXPECTED_PLATFORM." >&2
    echo ">> Rebuild with: PLATFORM=$EXPECTED_PLATFORM ./build.sh $VERSION" >&2
    exit 1
fi

docker tag "$LOCAL_IMAGE" "$REMOTE"

echo ">> About to push:"
echo "     local : $LOCAL_IMAGE"
echo "     remote: $REMOTE"
read -r -p ">> Type 'yes' to confirm push: " ack
if [ "$ack" != "yes" ]; then
    echo ">> Aborted; nothing pushed." >&2
    exit 1
fi

docker push "$REMOTE"
echo ">> pushed $REMOTE"
