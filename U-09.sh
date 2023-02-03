#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

>$TMP1

 

 

BAR

CODE [U-09] /etc/hosts 파일 소유자 및 권한 설정.

cat << EOF >> $result

[양호]: /etc/hosts 파일의 소유자가 root이고, 권한이 600인 경우

[취약]: /etc/hosts 파일의 소유자가 root가 아니거나, 권한이 600이 아닌 경우

EOF

BAR

 

# # 파일이 있는지 확인합니다
if [ -f /etc/hosts ]; then
  # # 파일이 루트에 의해 소유되는지 확인합니다
  if [ $(stat -c "%U" /etc/hosts) == "root" ]; then
    OK "/etc/hosts 파일이 루트에 의해 소유됩니다."
  else
    WARN "/etc/hosts 파일이 루트에 의해 소유되지 않습니다."
  fi

  # # 파일이 루트에 의해 소유되는지 확인합니다
  if [ $(stat -c "%a" /etc/hosts) -lt 600 ]; then
    OK "/etc/hosts 파일의 사용 권한이 600 미만입니다."
  else
    WARN "/etc/hosts 파일에 600 이상의 권한이 있습니다."
  fi
else
  OK "/etc/hosts 파일을 찾을 수 없습니다."
fi


cat $result

echo ; echo
