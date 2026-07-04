#!/usr/bin/env bash
# =============================================================================
# fetch_goldman_files.sh
#
# Place this file in the ROOT of Daemon-creates/ROGVE.
# Run it BEFORE running DreamMaker so that Goldman-licensed .dm files are
# fetched and overwrite the default versions before compilation.
#
# Optional environment variables:
#   GOLDMAN_API_URL  – base URL of the goldman-roguetown render.com service
#                     e.g. https://goldman-roguetown.onrender.com
#                     Defaults to the canonical hosted URL if not set.
#   GOLDMAN_API_KEY  – the API key issued by Jerry Goldman.
#                     If not set, default files are used and a warning is
#                     printed to the log.
#
# These variables may also be provided via a `.env` file instead of being
# exported directly. If GOLDMAN_API_KEY is not already set in the
# environment, this script automatically looks for (in order):
#   1. The file at ${GOLDMAN_ENV_FILE}, if that variable is set.
#   2. A `.env` file next to this script (e.g. the repo root when running
#      locally, such as via the VS Code "Build All" tasks / F5).
#   3. /tgstation/.env (the container path used by docker-entrypoint.sh and
#      the DockerTestServer entrypoint.sh).
# Environment variables already set take precedence over any `.env` file.
#
# Usage (non-Docker):
#   GOLDMAN_API_URL=https://... GOLDMAN_API_KEY=... bash fetch_goldman_files.sh
# =============================================================================

set -uo pipefail

# Auto-load a .env file if GOLDMAN_API_KEY hasn't already been exported.
if [[ -z "${GOLDMAN_API_KEY:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
  for CANDIDATE_ENV_FILE in "${GOLDMAN_ENV_FILE:-}" "${SCRIPT_DIR}/.env" "/tgstation/.env"; do
    if [[ -n "${CANDIDATE_ENV_FILE}" && -f "${CANDIDATE_ENV_FILE}" ]]; then
      echo "Loading environment variables from ${CANDIDATE_ENV_FILE}..."
      set -a
      # shellcheck disable=SC1090
      source "${CANDIDATE_ENV_FILE}"
      set +a
      break
    fi
  done
  unset SCRIPT_DIR CANDIDATE_ENV_FILE
fi

# Default to the canonical hosted URL if GOLDMAN_API_URL is not provided.
GOLDMAN_API_URL="${GOLDMAN_API_URL:-https://goldman-roguetown.onrender.com}"
GOLDMAN_APPLY_URL="${GOLDMAN_API_URL}/apply"

# If no API key is set, warn and fall back to whatever default files exist.
if [[ -z "${GOLDMAN_API_KEY:-}" ]]; then
  echo ""
  echo "=============================================================="
  echo "  NO JERRY GOLDMAN LICENSE FOUND -- CLICK HERE to apply:"
  echo "  ${GOLDMAN_APPLY_URL}"
  echo "  Falling back to default files."
  echo "=============================================================="
  echo ""
  exit 0
fi

# Fetch the manifest — a newline-separated list of every file under the
# code/, modular/, and tgui/ directories of goldman-roguetown. This means
# any file added to those directories is picked up automatically, with no
# need to edit this script.
MANIFEST=$(curl -sSL \
  --write-out "\n%{http_code}" \
  -H "Authorization: Bearer ${GOLDMAN_API_KEY}" \
  "${GOLDMAN_API_URL}/manifest" 2>&1) || true
MANIFEST_STATUS="${MANIFEST##*$'\n'}"
MANIFEST_BODY="${MANIFEST%$'\n'*}"

if [[ "${MANIFEST_STATUS}" != "200" ]]; then
  echo "ERROR: could not fetch manifest (HTTP ${MANIFEST_STATUS}) -- keeping default files." >&2
  echo ""
  echo "=============================================================="
  echo "  NO JERRY GOLDMAN LICENSE FOUND -- CLICK HERE to apply:"
  echo "  ${GOLDMAN_APPLY_URL}"
  echo "  Falling back to default files."
  echo "=============================================================="
  echo ""
  exit 0
fi

GOLDMAN_FILES=()
FETCH_FAILED=0
while IFS= read -r LINE; do
  if [[ -z "${LINE}" ]]; then
    continue
  fi
  # Reject anything that isn't a plain relative path: no leading slash, no
  # ".." or "./" traversal segments, no double slashes, no path segment
  # starting with "-" (which could be misread as a command flag), and only
  # characters expected in a repo path.
  if [[ "${LINE}" == /* || "${LINE}" == *".."* || "${LINE}" == *"./"* || "${LINE}" == *"//"* || \
        "${LINE}" == -* || "${LINE}" == *"/-"* || ! "${LINE}" =~ ^[A-Za-z0-9_./-]+$ ]]; then
    echo "WARNING: skipping unsafe manifest entry: ${LINE}" >&2
    FETCH_FAILED=1
    continue
  fi
  GOLDMAN_FILES+=("${LINE}")
done <<< "${MANIFEST_BODY}"

if [[ "${#GOLDMAN_FILES[@]}" -eq 0 ]]; then
  echo "Manifest is empty -- nothing to fetch."
  exit 0
fi

echo "Manifest lists ${#GOLDMAN_FILES[@]} file(s) to fetch from code/, modular/, and tgui/."

for FILE_PATH in "${GOLDMAN_FILES[@]}"; do
  echo "Fetching ${FILE_PATH} ..."
  mkdir -p "$(dirname "${FILE_PATH}")"
  TMP_FILE="${FILE_PATH}.goldman_tmp"
  HTTP_STATUS=$(curl -sSL \
    --write-out "%{http_code}" \
    --output "${TMP_FILE}" \
    -H "Authorization: Bearer ${GOLDMAN_API_KEY}" \
    "${GOLDMAN_API_URL}/file?path=${FILE_PATH}" 2>&1) || true
  if [[ "${HTTP_STATUS}" == "200" ]]; then
    mv "${TMP_FILE}" "${FILE_PATH}"
    echo "  -> saved to ${FILE_PATH}"
  else
    rm -f "${TMP_FILE}"
    echo "WARNING: could not fetch ${FILE_PATH} (HTTP ${HTTP_STATUS}) -- keeping default." >&2
    FETCH_FAILED=1
  fi
done

if [[ "${FETCH_FAILED}" -eq 1 ]]; then
  echo ""
  echo "=============================================================="
  echo "  One or more Goldman files could not be fetched."
  echo "  NO JERRY GOLDMAN LICENSE FOUND -- CLICK HERE to apply:"
  echo "  ${GOLDMAN_APPLY_URL}"
  echo "  Falling back to default files where fetch failed."
  echo "=============================================================="
  echo ""
else
  echo "All Goldman files fetched successfully."
fi
