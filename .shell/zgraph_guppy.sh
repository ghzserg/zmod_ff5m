#!/bin/sh

source /opt/config/mod/.shell/0.sh

unset LD_PRELOAD

if ! [ -f /THIS_IS_NOT_YOUR_ROOT_FILESYSTEM ]; then
    /opt/config/mod/.shell/root/zshaper/graph_belts.py $@
else
    [ ${NEED_REMOUNT} -eq 1 ] && umount ${UMOUNT_MOD}
    chroot ${MOD} /opt/config/mod/.shell/root/zshaper/graph_belts.py $@
    [ ${NEED_REMOUNT} -eq 1 ] && mount --bind ${REMOUNT_MOD} ${UMOUNT_MOD}
fi
