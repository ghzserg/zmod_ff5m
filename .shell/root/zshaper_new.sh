#!/bin/sh

SCV="5.0"
if grep -q "fix_scv = 1" /opt/config/mod_data/variables.cfg; then
    if grep -q '^square_corner_velocity' /opt/config/mod_data/user.cfg; then
        SCV=$(grep '^square_corner_velocity' /opt/config/mod_data/user.cfg| cut -d ":" -f 2 | awk '{print $1}')
        echo "Используется SCV (square_corner_velocity) = $SCV из mod_data/user.cfg"
    else if grep -q '^square_corner_velocity' /opt/config/printer.base.cfg; then
        SCV=$(grep '^square_corner_velocity' /opt/config/printer.base.cfg| cut -d ":" -f 2 | awk '{print $1}')
        echo "Используется SCV (square_corner_velocity) = $SCV из printer.base.cfg"
    else
        echo "Используется стандартный SCV (square_corner_velocity) = $SCV"
    fi
    fi
fi

DT=$(date '+%Y%m%d_%H%M')

cd /opt/config/mod_data/
mkdir -p shapers

echo "Подготовка изображения оси X. Ждите..."
sed 's/psd_x/psd_Y/' /tmp/resonances_x_x.csv | sed 's/psd_y/psd_x/' | sed 's/psd_Y/psd_y/' | awk -F ',' '{print $1","$3","$2","$4","$5}' >X
python3 /opt/config/mod/.shell/root/zshaper/calibrate_shaper.py X --scv=$SCV -o resonances_x.png -w 8 -l 4.8 --send X
mv X shapers/X_$DT.csv
cp resonances_x.png shapers/calibration_data_X_$DT.png

echo "Подготовка изображения оси Y. Ждите..."
sed 's/psd_x/psd_Y/' /tmp/resonances_y_y.csv | sed 's/psd_y/psd_x/' | sed 's/psd_Y/psd_y/' | awk -F ',' '{print $1","$3","$2","$4","$5}' >Y
python3 /opt/config/mod/.shell/root/zshaper/calibrate_shaper.py Y --scv=$SCV -o resonances_y.png -w 8 -l 4.8 --send Y
mv Y shapers/Y_$DT.csv
cp resonances_y.png shapers/calibration_data_Y_$DT.png

echo "Изображения лежат во вкладке Конфигурация -> mod_data resonances_x.png и resonances_y.png."
