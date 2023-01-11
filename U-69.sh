#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1   
 

BAR

CODE [U-69] NFS 설정파일 접근권한

cat << EOF >> $TMP1

[양호]: NFS 접근제어 설정파일의 소유자가 root 이고, 권한이 644 이하인 경우

[취약]: NFS 접근제어 설정파일의 소유자가 root 가 아니거나, 권한이 644 이하가 아닌 경우

EOF

BAR



# Check file owner
if [ "$(stat -c %U /etc/exports)" != "root" ]; then
    OK "파일 소유자가 루트가 아닙니다"
else
    WARN "파일 소유자가 루트입니다"
fi

# Check file permissions
if [ "$(stat -c %a /etc/exports)" -lt 644 ]; then
    OK "파일 권한이 644 미만입니다."
else
    WARN "파일 권한이 644 이상입니다."
fi



cat $TMP1

echo ; echo 

