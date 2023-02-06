#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1   
 

BAR

CODE [U-69] NFS 설정파일 접근권한

cat << EOF >> $result

[양호]: NFS 접근제어 설정파일의 소유자가 root 이고, 권한이 644 이하인 경우

[취약]: NFS 접근제어 설정파일의 소유자가 root 가 아니거나, 권한이 644 초과인 경우

EOF

BAR

TMP1=`SCRIPTNAME`.log

> $TMP1 

filename="/etc/exports"

if [ ! -e "$filename" ]; then
  WARN "$filename 가 존재하지 않습니다"
fi

owner=$(stat -c '%U' "$filename")
permission=$(stat -c '%a' "$filename")

if [ "$owner" != "root" ]; then
  WARN "$filename의 소유자가 루트가 아닙니다."
else
    OK "$filename의 소유자가 루트가 맞습니다."
fi

if [ $(expr "$permission" + 0) -gt 644 ]; then
  WARN "$filename의 권한이 644보다 큽니다."
else
    OK "$filename의 권한이 644 이하니다."
fi




cat $result

echo ; echo 

