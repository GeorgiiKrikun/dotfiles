#!/bin/bash
set -ex

if [ -f ${HOME}/.zshrc ];
then
    TIMESTAMP=$(date +%Y%m%d%H%M%S)
    BACKUP_FILE="${HOME}/.zshrc.bak.${TIMESTAMP}"
    echo "Zsh config already exists, backing it up to" "${BACKUP_FILE}"
    mv ${HOME}/.zshrc ${BACKUP_FILE}
fi

ln -s ${PWD}/.zshrc ${HOME}/.zshrc
