#!/usr/bin/env bash
# =============================================================================
# docker-entrypoint.sh
#
# Place this file in the ROOT of Daemon-creates/ROGVE and reference it as the
# Dockerfile ENTRYPOINT (see Dockerfile.runtime-entrypoint.txt).
#
# Unlike the old build-time integration, this script runs every time the
# CONTAINER STARTS (not just when the image is built). It:
#   1. Fetches the latest Goldman-licensed files via fetch_goldman_files.sh.
#   2. Recompiles roguetown.dme with DreamMaker, since .dm/.dmm source changes
#      only take effect once recompiled into the .dmb/.rsc binary.
#   3. Hands off to DreamDaemon (exec'd as PID 1) to actually run the server.
#
# Environment variables (must be set as RUNTIME env vars, not build args):
#   GOLDMAN_API_URL  – base URL of the goldman-roguetown service.
#                      Defaults to https://goldman-roguetown.onrender.com
#   GOLDMAN_API_KEY  – the API key issued by Jerry Goldman. If unset, the
#                      fetch script warns and leaves default files in place.
# =============================================================================

set -uo pipefail

echo "[entrypoint] Fetching latest Goldman-licensed files..."
GOLDMAN_API_URL="${GOLDMAN_API_URL:-https://goldman-roguetown.onrender.com}" \
  GOLDMAN_API_KEY="${GOLDMAN_API_KEY:-}" \
  bash /fetch_goldman_files.sh

echo "[entrypoint] Recompiling roguetown.dme..."
if ! DreamMaker -max_errors 0 roguetown.dme; then
  echo "[entrypoint] ERROR: DreamMaker compilation failed (see output above). Aborting startup." >&2
  exit 1
fi

echo "[entrypoint] Starting DreamDaemon..."
# Replace this with whatever arguments the ROGVE image normally passes to
# DreamDaemon (port, trusted mode, log paths, etc). Using exec keeps
# DreamDaemon as PID 1 so it receives signals (e.g. SIGTERM) correctly.
exec DreamDaemon roguetown.dmb -port "${PORT:-7777}" -trusted -close -verbose "$@"
