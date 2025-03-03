#!/bin/sh
#
# SSH for Telegram Bot
#

/opt/config/mod/.shell/znice.sh

/root/printer_data/scripts/zversion.sh

if [ $# -ne 8 ]; then echo "Используйте (START|STOP|RESTART|RELOAD) SSH_SERVER SSH_PORT SSH_USER VIDEO_PORT MOON_PORT REMOTE_RUN RESTART|NOTRESTART"; exit 1; fi

if ! [ -f /opt/config/mod_data/ssh.key ] || ! [ -f /opt/config/mod_data/ssh.pub.txt ]; then
    dropbearkey -t ed25519 -f /opt/config/mod_data/ssh.key
    dropbearkey -y -t ed25519 -f /opt/config/mod_data/ssh.key |grep root@kunos >/opt/config/mod_data/ssh.pub.txt
fi

SSH_PUB=$( cat /opt/config/mod_data/ssh.pub.txt )

START='off'
if [ $1 = "START" ]; then START='on'; fi;
if [ $1 = "RESTART" ]; then /etc/init.d/S98zssh restart; exit; fi
if [ $1 = "RELOAD" ];  then /etc/init.d/S98zssh reload;  exit; fi

if ! [ -f "/opt/config/mod_data/ssh.conf" ] || [ ${START} = 'on' ]
 then
echo "# Не редактируйте этот файл
# Используйте макрос
#
# ZSSH_ON SSH_SERVER=$2 SSH_PORT=$3 SSH_USER=$4 VIDEO_PORT=$5 MOON_PORT=$6
# или
# ZSSH_OFF
#
# Поместите текст строчкой ниже в ~/.ssh/authorized_keys для пользователя $4 на ssh сервере $2
# ${SSH_PUB}
# В файле authorized_keys уберите первые 2 символа '# ' - это коментарий

# Запускать ssh (on|off)
START=${START}

# Удаленный SSH сервер
SSH_SERVER=$2

# Порт SSH сервера (22)
SSH_PORT=$3

# Имя пользователя для авторизации
SSH_USER=$4

# Порт трансляции видео на удаленном сервере (8080)
VIDEO_PORT=$5

# Порт moonraker на удаленном сервере (7125)
MOON_PORT=$6

# Какую команду запускать на удаленном сервере (./ff5m.sh bot1)
REMOTE_RUN='$7'
" >/opt/config/mod_data/ssh.conf

echo "Поместите текст строчкой ниже в ~/.ssh/authorized_keys для пользователя $4 на ssh сервере $2"
echo "${SSH_PUB}"

else
    sed -i 's|START=.*|START=off|' /opt/config/mod_data/ssh.conf
fi

[ $8 = "RESTART" ] && /etc/init.d/S98zssh restart
