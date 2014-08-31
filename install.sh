#!/usr/bin/env bash 
OS=$(cat /etc/os-release | grep "^ID=" | cut -d "=" -f 2)

TR_DIR="${HOME}/.translator"
TR_SCR_PATH="${TR_DIR}/translator.sh"
TR_SCUT_PATH="${TR_DIR}/shortcut"

OBX_CNF_PATH="${HOME}/.config/openbox/lxde-rc.xml"

CMPT_CNF_PATTERN="shadow-exclude"
CMPT_CNF_REPLACEMENT="shadow-exclude = \[\"class_g = 'Xfce4-notifyd'\", \"class_g = 'Conky'\"\];"
CMPT_CNF_PATH="${HOME}/.config/compton.conf"

if [ "${OS}" == "rosa" ]; then
    ping -q -c 1 ya.ru > /dev/null 2>&1

    if [ ${?} -eq 0 ]; then
        echo "*** Устанавливаю необходимое ПО"

        while
            sudo -p "*** Введите пароль пользователя: " urpmi --force --quiet libnotify xsel wget > /dev/null 2>&1
            [ ${?} -ne 0 ]
        do
            continue
        done

        if [ ! -f ${TR_SCR_PATH} ]; then
            if [ ! -d ${TR_DIR} ]; then
                mkdir ${TR_DIR}
            fi

            echo "*** Загружаю скрипт"
            wget -q -P ${TR_DIR} https://raw.githubusercontent.com/snipers-pkb/rosa/master/translator.sh
            chmod +x ${TR_SCR_PATH}
        fi

        if [ -f ${OBX_CNF_PATH} ]; then
            cat ${OBX_CNF_PATH} | grep -q "translator.sh"

            if [ ${?} -ne 0 ]; then
                if [ ! -f ${TR_SCUT_PATH} ]; then
                    wget -q -P ${TR_DIR} https://raw.githubusercontent.com/snipers-pkb/rosa/master/shortcut
                fi

                echo "*** Назначаю комбинацию клавиш для скрипта"
                sed -ie "/<keyboard>/r ${TR_SCUT_PATH}" ${OBX_CNF_PATH}

                echo "*** Перезапускаю оконный менеджер"
                openbox --restart
            fi
        else
            echo "***"
            echo "*** !ВНИМАНИЕ!"
            echo "*** Не забудьте самостоятельно назначить"
            echo "*** комбинацию клавиш для скрипта"
            echo "*** ${TR_SCR_PATH}"
            echo "***"
        fi

        if [ -f ${CMPT_CNF_PATH} ]; then
            cat ${CMPT_CNF_PATH} | grep -q "^${CMPT_CNF_REPLACEMENT}"

            if [ ${?} -ne 0 ]; then
                echo "*** Редактирую файл конфигурации композитного менеджера"
                sed -ie "s/^${CMPT_CNF_PATTERN}/# ${CMPT_CNF_PATTERN}/g" ${CMPT_CNF_PATH}
                sed -ie "\$a\\${CMPT_CNF_REPLACEMENT}" ${CMPT_CNF_PATH}

                COMPTON_PID=$(pgrep compton)

                if  [ $? -eq 0 ]; then
                    echo "*** Перезапускаю композитный менеджер"
                    sleep 1

                    kill ${COMPTON_PID}
                    nohup compton > /dev/null 2>&1 &
                    sleep 1
                fi
            fi
        fi

        echo "*** Готово"
    else
        echo "*** Необходимо подключение к интернету"
    fi
else
    echo "*** Скрипт может быть запущен только в ОС ROSA Linux"
fi

printf "\n"
read -s -p "Для завершения нажмите 'Enter'"
printf "\n"
