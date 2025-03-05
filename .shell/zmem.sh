#!/bin/sh

/root/printer_data/scripts/ps_mem.py -S >/tmp/list.txt
awk '{
    gsub(/python3.7/, "Klipper");
    gsub(/python3.12/, "Moonraker");
    gsub(/firmwareExe/, "Экран");
    gsub(/mjpg_streamer/, "Камера");
    gsub(/dropbear/, "SSH сервер");
    gsub(/wpa_cli/, "Wi-Fi клиент");
    gsub(/console_log/, "Восстановление печати");
    gsub(/ts_uinput/, "Сенсорный ввод");
    gsub(/dbclient/, "SSH клиент");
    gsub(/guppyscreen/, "GuppyScreen");
    gsub(/wpa_supplicant/, "Wi-Fi сервер");
    gsub(/dbus-daemon/, "D-Bus");
    print;
}' /tmp/list.txt
rm -f /tmp/list.txt
free -m| sed 's/             total       used       free     shared    buffers     cached/Память       Всего     Занято   Свободно      Общая     Буферы        Кэш/'
