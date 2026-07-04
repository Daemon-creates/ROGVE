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

# The .dme project file whose include list must be kept in sync with
# whatever Goldman-licensed .dm files are fetched (relative to cwd, same
# as every other path this script deals with).
DME_FILE="${DME_FILE:-roguetown.dme}"

# A list of every file actually written to disk by this run, used by the
# Docker entrypoints to wipe the licensed source off the container's
# filesystem again once it has been compiled -- fetching it into a file on
# the machine and then leaving it there indefinitely would defeat the
# entire point of gating it behind an API key. Always start from a clean
# (empty) list, even if we bail out before fetching anything below.
GOLDMAN_FETCHED_LIST="${GOLDMAN_FETCHED_LIST:-.goldman_fetched_files.list}"
: > "${GOLDMAN_FETCHED_LIST}"

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
    echo "${FILE_PATH}" >> "${GOLDMAN_FETCHED_LIST}"
  else
    rm -f "${TMP_FILE}"
    echo "WARNING: could not fetch ${FILE_PATH} (HTTP ${HTTP_STATUS}) -- keeping default." >&2
    FETCH_FAILED=1
  fi
done

# Make sure every fetched/pre-existing .dm file is actually wired into the
# .dme's include list. DreamMaker only compiles files it is explicitly told
# about via "#include", so a new .dm file added upstream (in the manifest)
# would silently be ignored -- or break the build if something else assumes
# it exists -- unless we add an #include line for it here.
update_dme_includes() {
  if [[ ! -f "${DME_FILE}" ]]; then
    echo "WARNING: ${DME_FILE} not found -- skipping include list update." >&2
    return
  fi

  local file_path win_path
  local -a new_includes=()
  for file_path in "${GOLDMAN_FILES[@]}"; do
    # Only .dm files need (and can have) an #include entry; .dmm maps and
    # tgui assets are wired in differently (or not at all).
    [[ "${file_path}" == *.dm ]] || continue
    # Only add an include for files that actually exist on disk -- if the
    # fetch failed and there is no pre-existing default file either, adding
    # an #include for it would just break the compile.
    [[ -f "${file_path}" ]] || continue

    win_path="${file_path//\//\\}"
    if ! grep -qF "#include \"${win_path}\"" "${DME_FILE}"; then
      new_includes+=("#include \"${win_path}\"")
    fi
  done

  if [[ "${#new_includes[@]}" -eq 0 ]]; then
    return
  fi

  echo "Adding ${#new_includes[@]} new file(s) to ${DME_FILE}'s include list..."
  local tmp_dme="${DME_FILE}.goldman_tmp"
  local inserted=0
  : > "${tmp_dme}"
  while IFS= read -r LINE || [[ -n "${LINE}" ]]; do
    if [[ "${LINE}" == "// END_INCLUDE" && "${inserted}" -eq 0 ]]; then
      printf '%s\n' "${new_includes[@]}" >> "${tmp_dme}"
      inserted=1
    fi
    printf '%s\n' "${LINE}" >> "${tmp_dme}"
  done < "${DME_FILE}"

  if [[ "${inserted}" -eq 1 ]]; then
    mv "${tmp_dme}" "${DME_FILE}"
    echo "  -> ${DME_FILE} updated."
  else
    echo "WARNING: could not find // END_INCLUDE marker in ${DME_FILE} -- new files were NOT added." >&2
    rm -f "${tmp_dme}"
  fi
}

update_dme_includes

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
