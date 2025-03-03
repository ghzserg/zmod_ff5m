#!/bin/sh

set -x

for i in /opt/PROGRAM/control/*/; do 
    save_dir=$(pwd)
    echo "$i"
    if [ -d "$i" ]; then
        cd "$i"
        echo "">Update

        if [ "$1" -eq 1 ] && [ -f /THIS_IS_NOT_YOUR_ROOT_FILESYSTEM ]; then
            start-stop-daemon -S -b -x /opt/config/mod/.shell/update_mcu.sh -- mainboard
        else
            /usr/bin/audio_midi.sh For_Elise.mid
            sync
            sleep 5
            poweroff
        fi
        cd $save_dir
    fi
done
