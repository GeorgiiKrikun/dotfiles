#!/bin/bash
set -e

LINK_TARGET="${HOME}/.tmux.conf"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_DIR="${HOME}/.backups/tmux"
mkdir -p ${BACKUP_DIR}
BACKUP_FILE="${BACKUP_DIR}/${TIMESTAMP}"

if [ -L "${LINK_TARGET}" ] || [ -e "${LINK_TARGET}" ];
then
    echo "Tmux config already exists, backing it up to" "${BACKUP_FILE}"
    mv "${LINK_TARGET}" "${BACKUP_FILE}"
fi

ln -s "${PWD}/tmux-conf/.tmux.conf" "${LINK_TARGET}"

# Install TPM if not already present
if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    # Try to install plugins automatically
    ~/.tmux/plugins/tpm/bin/install_plugins || true
fi

echo "Tmux setup complete."
