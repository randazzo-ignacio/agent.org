#!/usr/bin/env bash

# Emacboros --- Agent orchestration in Emacs
# Copyright (C) 2026 Ignacio Agustín Randazzo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -euo pipefail

# =============================================================================
# Agentic Emacs -- Container Management Script
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="emacboros"
CONTAINER_NAME="emacboros"

# =============================================================================
# Build the container image from Containerfile
# =============================================================================
build() {
    echo "[emacboros] Building ${IMAGE_NAME} from ${SCRIPT_DIR}/containers/Containerfile..."
    podman build -t "${IMAGE_NAME}" -f "${SCRIPT_DIR}/containers/Containerfile"
    echo "[emacboros] Build complete."
}

# =============================================================================
# Run the container with .emacs.d mounted
# =============================================================================
run() {
    echo "[emacboros] Starting ${CONTAINER_NAME}..."

    # Generate read-only bind mounts for all agent prompt files and shared context.
    # This prevents shell-level tampering with agent prompts, which
    # file_guard.el cannot stop (it only intercepts Emacs tools, not
    # arbitrary shell commands via execute_code_local).
    local ro_mounts=""
    for prompt in "${SCRIPT_DIR}"/agents.d/*/prompt.org; do
        [ -f "$prompt" ] || continue
        local agent_name
        agent_name=$(basename "$(dirname "$prompt")")
        ro_mounts="${ro_mounts} -v ${prompt}:/root/.emacs.d/agents.d/${agent_name}/prompt.org:ro,Z"
    done

    # Read-only mount for base_context.org if it exists.
    if [ -f "${SCRIPT_DIR}/agents.d/base_context.org" ]; then
        ro_mounts="${ro_mounts} -v ${SCRIPT_DIR}/agents.d/base_context.org:/root/.emacs.d/agents.d/base_context.org:ro,Z"
    fi

    # Read-only mounts for critical infrastructure files.
    # These are the same paths protected by file_guard.el, but enforced
    # at the mount level so shell commands cannot bypass them.
    ro_mounts="${ro_mounts} -v ${SCRIPT_DIR}/.git:/root/.emacs.d/.git:ro,Z"
    ro_mounts="${ro_mounts} -v ${SCRIPT_DIR}/init.el:/root/.emacs.d/init.el:ro,Z"
    ro_mounts="${ro_mounts} -v ${SCRIPT_DIR}/init.d:/root/.emacs.d/init.d:ro,Z"
    ro_mounts="${ro_mounts} -v ${SCRIPT_DIR}/containers:/root/.emacs.d/containers:ro,Z"
    ro_mounts="${ro_mounts} -v ${SCRIPT_DIR}/emacboros.sh:/root/.emacs.d/emacboros.sh:ro,Z"

    # shellcheck disable=SC2086
    podman run \
        --rm -it --name "${CONTAINER_NAME}" \
        --read-only \
        --security-opt no-new-privileges \
        --cap-drop=all \
        --cap-add=NET_RAW \
        --cap-add=NET_BIND_SERVICE \
        --tmpfs /tmp:rw,size=256m \
        --tmpfs /run:rw,size=64m \
        --tmpfs /var/tmp:rw,size=64m \
        -v "${SCRIPT_DIR}:/root/.emacs.d:Z" \
        ${ro_mounts} \
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
