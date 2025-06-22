# #!/bin/bash
# set -ex
#
# if [ -f ${HOME}/.zshrc ];
# then
#     TIMESTAMP=$(date +%Y%m%d%H%M%S)
#     BACKUP_FILE="${HOME}/.zshrc.bak.${TIMESTAMP}"
#     echo "Zsh config already exists, backing it up to" "${BACKUP_FILE}"
#     mv ${HOME}/.zshrc ${BACKUP_FILE}
# fi
#
# ln -s ${PWD}/.zshrc ${HOME}/.zshrc
#
#!/bin/bash
set -ex

LINK_TARGET="${HOME}/.zshrc"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_DIR="${HOME}/.backups/zshrc"
mkdir -p ${BACKUP_DIR}
BACKUP_FILE="${BACKUP_DIR}/${TIMESTAMP}"

if [ -L ${LINK_TARGET} ] || -f ${LINK_TARGET} ];
then
    echo "Zsh config already exists, backing it up to" "${BACKUP_FILE}"
    mv ${LINK_TARGET} ${BACKUP_FILE}
fi

mkdir -p "$(dirname ${LINK_TARGET})"
ln -s ${PWD}/.zshrc ${LINK_TARGET}
