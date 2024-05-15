#!/bin/bash

function is_root() {
  if [ "$(id -u)" -eq 0 ]; then # you are root, set prompt password
    pass
  else # normal
    sudo -v
  fi
}

function backup_www() {
  readonly SOURCE_DIR="/www"
  readonly BACKUP_DIR="/back/www"
  readonly DATETIME="$(date '+%Y-%m-%d_%H:%M:%S')"
  readonly BACKUP_PATH="${BACKUP_DIR}/${DATETIME}"
  readonly LATEST_LINK="${BACKUP_DIR}/latest"


  if [ "$(ls -D1t "${BACKUP_DIR}" | wc --lines)" ] -gt 15; then
    rm -rf "$(ls -D1t | tail -1)"
  fi

  mkdir -p "${BACKUP_DIR}"
  rsync -avzh --progress --delete \
    "${SOURCE_DIR}/" \
    --link-dest "${LATEST_LINK}" \
    "${BACKUP_PATH}"

  rm -rf "${LATEST_LINK}"
  ln -s "${BACKUP_PATH}" "${LATEST_LINK}"

}

function backup_share() {
  readonly SOURCE_DIR="/share"
  readonly BACKUP_DIR="/back/share"
  readonly DATETIME="$(date '+%Y-%m-%d_%H:%M:%S')"
  readonly BACKUP_PATH="${BACKUP_DIR}/${DATETIME}"
  readonly LATEST_LINK="${BACKUP_DIR}/latest"

  is_root

  if [ "$(ls -D1t "${BACKUP_DIR}" | wc --lines)" ] -gt 15; then
    rm -rf "$(ls -D1t | tail -1)"
  fi

  mkdir -p "${BACKUP_DIR}"
  rsync -avhz --progress --delete \
    "${SOURCE_DIR}/" \
    --link-dest "${LATEST_LINK}" \
    "${BACKUP_PATH}"

  rm -rf "${LATEST_LINK}"
  ln -s "${BACKUP_PATH}" "${LATEST_LINK}"

}

is_root
sudo mount /dev/mapper/rl-back

set -o errexit
set -o nounset
set -o pipefail

backup_share
backup_www

umount /dev/mapper/rl-back

