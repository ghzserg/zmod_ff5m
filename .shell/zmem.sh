#!/bin/sh

/root/printer_data/scripts/ps_mem.py -S >/tmp/list.txt
sed 's/python3.7/Klipper/' /tmp/list.txt | sed 's/python3.11/Moonraker/' | sed 's/firmwareExe/Экран/' | sed 's/mjpg_streamer/Камера/'
rm -f /tmp/list.txt
free -m| sed 's/             total       used       free     shared    buffers     cached/Память       Всего     Занято   Свободно      Общая     Буферы        Кэш/'
