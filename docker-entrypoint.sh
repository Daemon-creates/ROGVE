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
#   3. Deletes the Goldman-licensed source files that were just fetched (via
#      cleanup_goldman_files.sh), so the licensed .dm source doesn't sit
#      around in plaintext on this machine for the lifetime of the container
#      -- only the compiled .dmb/.rsc (which DreamDaemon actually needs)
#      remains on disk. This is the entire point of gating the source behind
#      the API key in the first place.
#   4. Hands off to DreamDaemon (exec'd as PID 1) to actually run the server.
#
# Environment variables (may be set as RUNTIME env vars, or via a `.env`
# file — see fetch_goldman_files.sh for the `.env` lookup/precedence rules):
#   GOLDMAN_API_URL  – base URL of the goldman-roguetown service.
#                      Defaults to https://goldman-roguetown.onrender.com
#   GOLDMAN_API_KEY  – the API key issued by Jerry Goldman. If unset, the
#                      fetch script warns and leaves default files in place.
#
# To use a `.env` file, mount/copy it to /tgstation/.env (e.g.
# `-v $(pwd)/.env:/tgstation/.env:ro` when using `docker run`, or
# `env_file: .env` when using docker-compose).
# =============================================================================

set -uo pipefail

# Deletes every Goldman-licensed source file fetched by fetch_goldman_files.sh
# in this run, so it doesn't linger in plaintext on this machine's disk.
# Called both after a successful compile and before aborting on failure.
# See cleanup_goldman_files.sh for details.
cleanup_goldman_files() {
  bash /cleanup_goldman_files.sh
}

echo "[entrypoint] Fetching latest Goldman-licensed files..."
bash /fetch_goldman_files.sh

echo "[entrypoint] Recompiling roguetown.dme..."
COMPILE_STATUS=0
DreamMaker -max_errors 0 roguetown.dme || COMPILE_STATUS=$?

cleanup_goldman_files

if [[ "${COMPILE_STATUS}" -ne 0 ]]; then
  echo "[entrypoint] ERROR: DreamMaker compilation failed (see output above). Aborting startup." >&2
  exit 1
fi

echo "[entrypoint] Starting DreamDaemon..."
# Replace this with whatever arguments the ROGVE image normally passes to
# DreamDaemon (port, trusted mode, log paths, etc). Using exec keeps
# DreamDaemon as PID 1 so it receives signals (e.g. SIGTERM) correctly.
exec DreamDaemon roguetown.dmb -port "${PORT:-7777}" -trusted -close -verbose "$@"
