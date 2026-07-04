#!/usr/bin/env bash
# =============================================================================
# cleanup_goldman_files.sh
#
# Place this file in the ROOT of Daemon-creates/ROGVE, alongside
# fetch_goldman_files.sh.
#
# Puts the working tree back exactly how it was before
# fetch_goldman_files.sh ran, using the GOLDMAN_FETCHED_LIST manifest it
# wrote:
#   - Files that were newly added (didn't exist before the fetch) are
#     deleted.
#   - Files that already existed as the default (non-licensed) version and
#     were merely overwritten -- including roguetown.dme, if its include
#     list was updated -- are restored from the backup copy
#     fetch_goldman_files.sh stashed in GOLDMAN_BACKUP_DIR.
# This ensures the fetched Goldman-licensed plaintext source doesn't linger
# on disk once it's no longer needed (e.g. right after DreamMaker has
# compiled it into the .dmb/.rsc), without destroying any pre-existing
# default files in the process. This is the entire point of gating the
# source behind an API key in the first place -- fetching it and then
# leaving it (or a permanently modified default file) on disk indefinitely
# would defeat it completely.
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
GOLDMAN_BACKUP_DIR="${GOLDMAN_BACKUP_DIR:-.goldman_backup}"

if [[ ! -f "${GOLDMAN_FETCHED_LIST}" ]]; then
  exit 0
fi

echo "[goldman] Restoring working tree to its pre-fetch state..."
while IFS= read -r ENTRY || [[ -n "${ENTRY}" ]]; do
  # Strip a trailing carriage return in case the list was ever written or
  # read with CRLF line endings (e.g. some Windows tooling).
  ENTRY="${ENTRY%$'\r'}"
  [[ -n "${ENTRY}" ]] || continue

  MARKER="${ENTRY:0:1}"
  FETCHED_FILE="${ENTRY:2}"
  [[ -n "${FETCHED_FILE}" ]] || continue

  case "${MARKER}" in
    A)
      # Didn't exist before the fetch -- remove it entirely.
      rm -f -- "${FETCHED_FILE}"
      ;;
    M)
      # Existed before the fetch and was overwritten -- restore the
      # original from backup instead of deleting it.
      BACKUP_FILE="${GOLDMAN_BACKUP_DIR}/${FETCHED_FILE}"
      if [[ -f "${BACKUP_FILE}" ]]; then
        mkdir -p "$(dirname "${FETCHED_FILE}")"
        mv -f -- "${BACKUP_FILE}" "${FETCHED_FILE}"
      else
        echo "WARNING: no backup found for ${FETCHED_FILE} -- leaving it as-is." >&2
      fi
      ;;
    *)
      # Unrecognized/legacy entry (e.g. from an older version of this
      # manifest that didn't record A/M markers) -- fall back to the old
      # delete-only behavior for that single entry.
      rm -f -- "${ENTRY}"
      ;;
  esac
done < "${GOLDMAN_FETCHED_LIST}"

rm -rf -- "${GOLDMAN_BACKUP_DIR}"
rm -f -- "${GOLDMAN_FETCHED_LIST}"

