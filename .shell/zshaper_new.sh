#!/bin/sh

source /opt/config/mod/.shell/0.sh

unset LD_PRELOAD

if [ -f /ZMOD ]; then
    /opt/config/mod/.shell/root/zshaper_new.sh $@
else
    [ ${FF5X} -eq 0 ] && while umount ${UMOUNT_MOD} 2>/dev/null; do a=b; done
    chroot ${MOD} /opt/config/mod/.shell/root/zshaper_new.sh $@
    [ ${FF5X} -eq 0 ] && mount --bind ${REMOUNT_MOD} ${UMOUNT_MOD}
fi
