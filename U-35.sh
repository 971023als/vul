#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1  

 

BAR

CODE [U-35] Apache 디렉터리 리스팅 제거

cat << EOF >> $TMP1

[양호]: 디렉터리 검색 기능을 사용하지 않는 경우

[취약]: 디렉터리 검색 기능을 사용하는 경우

EOF

BAR



# Set the Apache2 configuration file path
config_file="/etc/apache2/apache2.conf"

# Use grep to check if the directory listing is enabled in the configuration file
result=$(grep -E "^[ \t]*Options[ \t]+Indexes" $config_file)

if [ -n "$result" ]; then
    WARN "Apache2 서버에서 디렉터리 목록이 사용 가능합니다."
else
    OK "Apache2 서버에서 디렉터리 목록이 사용 가능하지 않습니다."
fi


cat $TMP1

echo ; echo
