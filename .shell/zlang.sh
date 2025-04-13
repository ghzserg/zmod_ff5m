#!/bin/sh

source /opt/config/mod/.shell/0.sh

if [ "$1" == 'en' ]; then ZLANG="en" 
else if [ "$1" == 'de' ]; then ZLANG="de" 
else if [ "$1" == 'ru' ]; then ZLANG="ru"
else ZLANG="ru"
fi
fi
fi

echo "[zmod]
language: ${ZLANG}" >${MOD_CONF}/mod_data/lang.cfg

sync
sleep 5
sync
reboot
