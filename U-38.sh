#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-38] Apache 불필요한 파일 제거 

cat << EOF >> $result

[양호]: 매뉴얼 파일 및 디렉터리가 제거되어 있는 경우

[취약]: 매뉴얼 파일 및 디렉터리가 제거되지 않은 경우

EOF

BAR

HTTPD_ROOT="/etc/apache2/apache2.conf"
UNWANTED_ITEMS="manual samples docs"

if [ `ps -ef | grep httpd | grep -v "grep" | wc -l` -eq 0 ]; then
    echo "Apache is not running."
else
    for item in $UNWANTED_ITEMS
    do
        if [ ! -d "$HTTPD_ROOT/$item" ] && [ ! -f "$HTTPD_ROOT/$item" ]; then
            echo "$item not found in $HTTPD_ROOT"
        fi
    done
fi


cat $result

echo ; echo