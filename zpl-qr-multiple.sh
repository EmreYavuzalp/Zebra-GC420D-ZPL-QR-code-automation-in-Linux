#!/bin/bash

WIFI_FILE="wifi.txt"
SSID=$(sed -n '3p' wifi.txt)
PASSWORD=$(sed -n '4p' wifi.txt)

QRDATA="WIFI:T:WPA;S:$SSID;P:$PASSWORD;;"

mapfile -t LINES < <(grep -v '^$' "$WIFI_FILE")

TOTAL=${#LINES[@]}

# 3'erli bloklar halinde dön
for ((i=0; i<TOTAL; i+=3)); do
    PRINT_NO="${LINES[i]}"
    SSID="${LINES[i+1]}"
    PASSWORD="${LINES[i+2]}"

    QRDATA="WIFI:T:WPA;S:$SSID;P:$PASSWORD;;"
    echo "Basılıyor: $PRINT_NO - $SSID"

cat <<EOF | tee /dev/usb/lp0 > /dev/null
^XA
^CI28
^MMT
^PW440
^LL320
^LT0
^LS0

; --- QR CODE (SOL) ---
^FO10,50
^BQN,2,6
^FDLA,$QRDATA^FS

; --- METİNLER (QR SAĞI) ---
^FO230,60^A0N,22,22^FD$SSID^FS
^FO230,95^A0N,22,22^FDWi-Fi için okutunuz^FS
^FO230,125^A0N,24,24^FDArı Bilişim^FS
^FO230,155^A0N,22,22^FDİletişim no:^FS
^FO230,180^A0N,22,22^FDyour_number^FS
^FO230,210^A0N,22,22^FDWeb Sitemiz:^FS
^FO230,235^A0N,22,22^FDyour_site^FS
^FO230,260^A0N,22,22^FDP. NO: $PRINT_NO^FS



^XZ
EOF

    sleep 0.5   # Yazıcıya nefes alma payı
done
