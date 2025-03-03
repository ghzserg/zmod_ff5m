#!/bin/sh

if ! [ -f /THIS_IS_NOT_YOUR_ROOT_FILESYSTEM ]; then
    echo "Проверка системы из Klipper 12 не поддерживается. Используйте родной Klipper 11."
    exit
fi

restore_file()
{
    fname="$1"
    echo -n "Восстанавливаю файл $fname: "
    if /opt/cloud/curl-7.55.1-https/bin/curl --create-dirs -s -k -H 'Accept: application/vnd.github.v3.raw' -o "$fname" -L "https://api.github.com/repos/ghzserg/zmod/contents/stock${fname}"; then
        chmod 777 "$fname"
        echo "Успешно"
    else
        echo "Ошибка восстановления"
    fi
}

echo "Началась проверка. Она может занять много времени...."

find /opt/PROGRAM/ -name md5sum.list | while read a;
    do
        b=$(pwd)
        c=$(echo $a|sed 's/md5sum.list//')
        echo "$c"
        cd "$c"
        if echo $c | grep -q control; then
            touch Update
        fi
        md5sum -c md5sum.list 2>/dev/null | grep -v -e "OK$"
        if echo $c | grep -q control; then
            rm -f Update
        fi
        cd "$b"
    done

echo "/"
cd /
FF_VERSION="$(cat /root/version)"
MIN_VERSION="3.1.3"
if [ "${FF_VERSION//./}" -lt "${MIN_VERSION//./}" ]; then
    sed '/\/nim\//d' /opt/config/mod/.shell/md5sum.list >/opt/config/mod/.shell/md5sum_nim.list
    md5sum -c /opt/config/mod/.shell/md5sum_nim.list 2>/dev/null | grep -v -e "OK$" | tee /opt/config/mod/bad.list
    rm -f /opt/config/mod/.shell/md5sum_nim.list
else
    md5sum -c /opt/config/mod/.shell/md5sum.list 2>/dev/null | grep -v -e "OK$" | tee /opt/config/mod/bad.list
fi

if [ "$1" == "restore" ]; then
    cat /opt/config/mod/bad.list|grep ": FAILED$"|sed 's|: FAILED||' | sed 's|^./|/|' | while read a; do restore_file "$a"; done
fi
rm -f /opt/config/mod/bad.list

if [ "${FF_VERSION//./}" -lt "${MIN_VERSION//./}" ]; then
    sed '/\/nim\//d' /opt/config/mod/.shell/list.link >/opt/config/mod/.shell/md5sum_nim.list
    chmod +x /opt/config/mod/.shell/md5sum_nim.list
    /opt/config/mod/.shell/md5sum_nim.list 2>/dev/null
    rm -f /opt/config/mod/.shell/md5sum_nim.list
else
    /opt/config/mod/.shell/list.link 2>/dev/null
fi

echo "Оригиналы файлов можно найти по ссылке https://github.com/ghzserg/zmod/tree/main/stock"
