#!/bin/sh

MOD=/data/.mod/.zmod

unset LD_PRELOAD

up()
{
    if [ -f /THIS_IS_NOT_YOUR_ROOT_FILESYSTEM ]; then
        umount /data/.mod/
        chroot $MOD /etc/init.d/S80guppyscreen start &
        sleep 15
        mount --bind /data/lost+found /data/.mod
    else
        /etc/init.d/S80guppyscreen up
    fi
}

stop()
{
    if [ -f /THIS_IS_NOT_YOUR_ROOT_FILESYSTEM ]; then
        umount /data/.mod/
        chroot $MOD /etc/init.d/S80guppyscreen stop &
        sleep 15
        mount --bind /data/lost+found /data/.mod
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
