#!/bin/sh

MOD=/data/.mod/.zmod

unset LD_PRELOAD

if [ "$1" == "test" ] && [ -f /opt/config/mod_data/klipper_data.json ]; then
    echo "!! Найдена незаконченная печать, используйте ZRESTORE для восстановления !!"
    echo "Для удаления данных восстановления ZRESTORE TEST=2"
    echo _ZRESTORE >/tmp/printer
    exit
fi

if [ -f /opt/config/mod_data/klipper_data.json ]; then
    if [ -f /THIS_IS_NOT_YOUR_ROOT_FILESYSTEM ]; then
        umount /data/.mod/
        chroot $MOD /opt/config/mod/.shell/root/restore_gcode
        mount --bind /data/lost+found /data/.mod
    else
        /opt/config/mod/.shell/root/restore_gcode
    fi
else
    echo "Файл восстановления печати не найден"
fi
