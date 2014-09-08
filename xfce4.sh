#!/bin/bash
INSTALL_DIR=${1:-${HOME}/.translator/}

#Trying xsel
which xsel > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "xsel is required. Try \"apt-get install xsel\""
    exit 1
fi

#Trying notify-send
which notify-send > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "notify-send is required. Try \"apt-get install libnotify-bin\""
    exit 1
fi

SCRIPT_DIR=$(cd `dirname "$0"`; pwd -P)
if [[ ! -f ${SCRIPT_DIR}/translator.sh ]]; then
    echo "Something happens. There is no 'translator.sh' in ${SCRIPT_DIR}"
    exit 1
fi

mkdir ${INSTALL_DIR}
cp ${SCRIPT_DIR}/translator.sh ${INSTALL_DIR}
chmod u+x ${INSTALL_DIR}/translator.sh
xfconf-query --channel xfce4-keyboard-shortcuts --property "/commands/custom/<Super>t" --create --type string --set "${INSTALL_DIR}translator.sh"