#!/bin/bash
set -ex

LINK_TARGET="${HOME}/.config/nvim"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_DIR="${HOME}/.backups/nvim"
mkdir -p ${BACKUP_DIR}
BACKUP_FILE="${BACKUP_DIR}/${TIMESTAMP}"

if [ -L ${LINK_TARGET} ] || [ -e ${LINK_TARGET} ];
then
    echo "NeoVim config already exists, backing it up to" "${BACKUP_FILE}"
    mv ${LINK_TARGET} ${BACKUP_FILE}
fi

mkdir -p "$(dirname ${LINK_TARGET})"
ln -s ${PWD}/nvim-conf ${LINK_TARGET}
