#!/bin/sh

source /opt/config/mod/.shell/0.sh

unset LD_PRELOAD

up()
{
    if ! [ -f /ZMOD ]; then
        [ ${NEED_REMOUNT} -eq 1 ] && umount ${UMOUNT_MOD}
        chroot ${MOD} /etc/init.d/S80guppyscreen start &
        sleep 15
        [ ${NEED_REMOUNT} -eq 1 ] && mount --bind ${REMOUNT_MOD} ${UMOUNT_MOD}
    else
        /etc/init.d/S80guppyscreen up
    fi
}

stop()
{
    if ! [ -f /ZMOD ]; then
        [ ${NEED_REMOUNT} -eq 1 ] && umount ${UMOUNT_MOD}
        chroot ${MOD} /etc/init.d/S80guppyscreen stop &
        sleep 15
        [ ${NEED_REMOUNT} -eq 1 ] && mount --bind ${REMOUNT_MOD} ${UMOUNT_MOD}
    else
        /etc/init.d/S80guppyscreen stop
    fi
}

case "$1" in
    up)
        up
        ;;
    stop)
        stop
        ;;
    *)
        echo "Usage: $0 {stop|up}"
        exit 1
esac
sync
echo 3 > /proc/sys/vm/drop_caches
exit $?
