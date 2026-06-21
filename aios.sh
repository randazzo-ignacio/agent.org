#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Agentic Emacs -- Container Management Script
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="agentic-emacs"
CONTAINER_NAME="emacs-ai-os"

# =============================================================================
# Build the container image from Containerfile
# =============================================================================
build() {
    echo "[aios] Building ${IMAGE_NAME} from ${SCRIPT_DIR}/Containerfile..."
    podman build -t "${IMAGE_NAME}" -f "${SCRIPT_DIR}/Containerfile"
    echo "[aios] Build complete."
}

# =============================================================================
# Run the container with .emacs.d mounted
# =============================================================================
run() {
    echo "[aios] Starting ${CONTAINER_NAME}..."
    podman run \
        --rm -it --name "${CONTAINER_NAME}" \
        -v "${HOME}/.emacs.d:/root/.emacs.d:Z" \
        "${IMAGE_NAME}"
}

# =============================================================================
# Rebuild and run
# =============================================================================
rebuild() {
    build
    run
}

# =============================================================================
# Entrypoint
# =============================================================================
case "${1:-run}" in
    build)
        build
        ;;
    run)
        run
        ;;
    rebuild)
        rebuild
        ;;
    *)
        echo "Usage: $0 {build|run|rebuild}"
        echo "  build    - Build the container image from Containerfile"
        echo "  run      - Run the container (default)"
        echo "  rebuild  - Build and run"
        exit 1
        ;;
esac