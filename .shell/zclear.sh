#!/bin/bash

if  [ "$1" == 1 ]
    then
        rm -rf /data/logFiles/*
        rm -rf /opt/config/mod_data/log/*
        sync
fi

if  [ "$2" == 1 ]
    then
        find /data/ -type f -not -regex "/data/lost+found/.*" -not -regex "/data/\.mod/.*" -not -regex "/data/logFiles.*" -exec rm {} \;
        sync
        find /data/ -type d -not -regex "/data/\.mod.*"  -not -regex "/data/lost+found.*" -not -path "/data/" -not -path "/data/logFiles" -exec rm -r {} \;
        sync
fi
