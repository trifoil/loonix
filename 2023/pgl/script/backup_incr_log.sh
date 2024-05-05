#!/bin/bash

function is_root() {
  if [ "$(id -u)" -eq 0 ]; then # you are root, set prompt password
    pass
  else # normal
    sudo -v
  fi
}

set -o errexit
set -o nounset
set -o pipefail

readonly SOURCE_DIR="/var/log/"
readonly BACKUP_DIR="/back/log"
readonly DATETIME="$(date '+%Y-%m-%d_%H:%M:%S')"
readonly BACKUP_PATH="${BACKUP_DIR}/${DATETIME}"
readonly LATEST_LINK="${BACKUP_DIR}/latest"

is_root

sudo mount /dev/mapper/rl-back_log
if [ "$(ls -D1t "${BACKUP_DIR}" | wc --lines)" ] -gt 30 ; then
  rm -rf "$(ls -D1t | tail -1)"
fi

mkdir -p "${BACKUP_DIR}"
rsync -avzh --progress --delete \
  "${SOURCE_DIR}/" \
  --link-dest "${LATEST_LINK}" \
  "${BACKUP_PATH}"

rm -rf "${LATEST_LINK}"
ln -s "${BACKUP_PATH}" "${LATEST_LINK}"

umount /dev/mapper/rl-back_log
