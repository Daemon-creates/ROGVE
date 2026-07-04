#!/usr/bin/env bash
# =============================================================================
# cleanup_goldman_files.sh
#
# Place this file in the ROOT of Daemon-creates/ROGVE, alongside
# fetch_goldman_files.sh.
#
# Deletes every Goldman-licensed source file recorded by
# fetch_goldman_files.sh (via the GOLDMAN_FETCHED_LIST manifest) so the
# fetched plaintext source doesn't linger on disk once it's no longer needed
# (e.g. right after DreamMaker has compiled it into the .dmb/.rsc). This is
# the entire point of gating the source behind an API key in the first
# place -- fetching it and then leaving it on disk indefinitely would defeat
# it completely.
#
# This MUST run after every invocation of fetch_goldman_files.sh, in every
# environment that can run it -- not just inside Docker. That includes local
# (non-Docker) builds, such as the VS Code "Build All" task on Windows, which
# runs fetch_goldman_files.sh directly on the developer's own machine.
#
# Usage:
#   bash cleanup_goldman_files.sh
# =============================================================================

set -uo pipefail

GOLDMAN_FETCHED_LIST="${GOLDMAN_FETCHED_LIST:-.goldman_fetched_files.list}"

if [[ ! -f "${GOLDMAN_FETCHED_LIST}" ]]; then
  exit 0
fi

echo "[goldman] Removing fetched Goldman-licensed source files from disk..."
while IFS= read -r FETCHED_FILE || [[ -n "${FETCHED_FILE}" ]]; do
  # Strip a trailing carriage return in case the list was ever written or
  # read with CRLF line endings (e.g. some Windows tooling).
  FETCHED_FILE="${FETCHED_FILE%$'\r'}"
  [[ -n "${FETCHED_FILE}" ]] || continue
  rm -f -- "${FETCHED_FILE}"
done < "${GOLDMAN_FETCHED_LIST}"
rm -f -- "${GOLDMAN_FETCHED_LIST}"
