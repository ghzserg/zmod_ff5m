#!/bin/sh

set -x

MOD=/data/.mod/.zmod

start_moon()
{
    SWAP="/root/swap"
    if grep -q "use_swap = 2" /opt/config/mod_data/variables.cfg; then
        for i in `seq 1 6`; do mount |grep /media && break; echo $i; sleep 10; done;

        if mount |grep /media; then
            FREE_SPACE=$(df /media 2>/dev/null|grep -v /dev/root|grep -v Filesystem| tail -1 | tr -s ' ' | cut -d' ' -f4)
            MIN_SPACE=$((128*1024))
            mount
            df /media

            if [ "$FREE_SPACE" != "" ] && [ "$FREE_SPACE" -ge "$MIN_SPACE" ]; then
                SWAP="/media/swap"
                if ! [ -f $SWAP ]; then dd if=/dev/zero of=$SWAP bs=1024 count=131072; mkswap $SWAP; fi;
                swapon $SWAP
            fi
        fi
    fi

    MACHINE="Неизвестная машина"
    grep -q '^MACHINE=Adventurer5MPro$' /opt/auto_run.sh && MACHINE=Adventurer5MPro
    grep -q '^MACHINE=Adventurer5M$' /opt/auto_run.sh && MACHINE=Adventurer5M
    VER=$(cat /root/version)
    chroot $MOD /opt/config/mod/.shell/root/start.sh "$SWAP" "$VER" "$MACHINE" &

    mkdir -p /data/lost+found
    sleep 10
    mount --bind /data/lost+found /data/.mod
    mount
    ps
    sleep 60
    umount /opt/klipper/start.sh
}

start_prepare()
{
    /opt/config/mod/.shell/znice.sh

    [ -L /etc/init.d/S00fix ] || ln -s /opt/config/mod/.shell/fix_config.sh /etc/init.d/S00fix
    echo "System start" >/opt/config/mod_data/log/ssh.log
    mount -t proc /proc $MOD/proc
    mount --rbind /sys $MOD/sys
    mount --rbind /dev $MOD/dev

    mount --bind /tmp $MOD/tmp
    mount --bind /run $MOD/run

    mkdir -p $MOD/opt/config
    mount --bind /opt/config $MOD/opt/config

    mkdir -p $MOD/data
    mount --bind /data $MOD/data
#    mount --bind /mnt/usb $MOD/data/usb

#    mkdir -p $MOD/var/run/
#    mount --bind /var/run/ $MOD/var/run/

    mkdir -p $MOD/opt/PROGRAM/
    mount --bind /opt/PROGRAM/ $MOD/opt/PROGRAM/

    mkdir -p $MOD/root/printer_data/misc
    mkdir -p $MOD/root/printer_data/tmp
    mkdir -p $MOD/root/printer_data/comms
    mkdir -p $MOD/root/printer_data/certs

    if  ! [ -d $MOD/opt/klipper/docs ]
     then
        mkdir -p $MOD/opt/klipper/docs
        cp /opt/klipper/docs/* $MOD/opt/klipper/docs
    fi

    if ! [ -d $MOD/opt/klipper/config ]
     then
        mkdir -p $MOD/opt/klipper/config
        cp /opt/klipper/config/* $MOD/opt/klipper/config
    fi

    cat /etc/localtime >/tmp/localtime
    cp /opt/tslib-1.12/etc/pointercal /tmp/pointercal
    cp /opt/tslib-1.12/etc/ts.conf /tmp/ts.conf

    start_moon
}

if [ -f /opt/config/mod/SKIP_ZMOD ]
 then
    rm -f /opt/config/mod/SKIP_ZMOD
    mount --bind /data/lost+found /data/.mod
    exit 0
fi

if [ -f /opt/config/mod/REMOVE ] || [ -f /opt/config/mod/FULL_REMOVE ]; then
  sync
  exit 0
fi

while ! mount |grep /dev/mmcblk0p7; do sleep 10; done

mv /opt/config/mod_data/log/zmod.4.log /opt/config/mod_data/log/zmod.5.log
mv /opt/config/mod_data/log/zmod.3.log /opt/config/mod_data/log/zmod.4.log
mv /opt/config/mod_data/log/zmod.2.log /opt/config/mod_data/log/zmod.3.log
mv /opt/config/mod_data/log/zmod.1.log /opt/config/mod_data/log/zmod.2.log
mv /opt/config/mod_data/log/zmod.log /opt/config/mod_data/log/zmod.1.log
start_prepare &>/opt/config/mod_data/log/zmod.log
