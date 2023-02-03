#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1
 

BAR

CODE [U-55] hosts.lpd 파일 소유자 및 권한 설정

cat << EOF >> $result

[양호]: 파일의 소유자가 root이고 권한이 600인 경우

[취약]: 파일의 소유자가 root가 아니고 권한이 600이 아닌 경우

EOF

BAR


# 파일이 있는지 확인하십시오
if [ ! -f /etc/hosts.lpd ]; then
  WARN "hosts.lpd 파일이 없습니다. 확인해주세요."
fi

hosts=$(stat -c '%U' /etc/hosts.lpd)
if [[ $hosts = "root" ]]; then
  WARN "Owner of hosts.lpd의 소유자는 루트입니다. 이것은 허용되지 않습니다."
fi

# 파일에 대한 사용 권한 확인

host=$(stat -c %a /etc/hosts.lpd)
if [[ $host = "600" ]]; then
  WARN  "hosts.lpd에 대한 권한이 600으로 설정되었습니다. 이것은 허용되지 않습니다."
fi

OK "https.lpd 파일이 있고 소유자와 권한이 예상대로입니다."


cat $result

echo ; echo
