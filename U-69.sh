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

filename="/etc/exports"

if [ ! -e "$filename" ]; then
  echo "$filename does not exist."
fi

owner=$(stat -c '%U' "$filename")
permission=$(stat -c '%a' "$filename")

if [ "$owner" != "root" ]; then
  echo "The owner of $filename is not root."
fi

if [ "$permission" -gt 644 ]; then
  echo "The permission of $filename is greater than 644."
fi




cat $result

echo ; echo 

