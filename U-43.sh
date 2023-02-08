#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1 

 

BAR

CODE [U-43] 로그의 정기적 검토 및 보고

cat << EOF >> $result

[양호]: 로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지는 경우

[취약]: 로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지지 않는 경우는 경우

EOF

BAR

# su 시도에 관한 로그 검토

# su 명령을 통해 sulog에서 권한 상승 시도 여부를 점검하십시오
allowed_accounts=(
  "root"
  "bin"
  "daemon"
  "adm"
  "lp"
  "sync"
  "shutdown"
  "halt"
  "ubuntu"
  "user"
  "messagebus"
  "syslog"
  "avahi"
  "kernoops"
  "whoopsie"
  "colord"
  "systemd-network"
  "systemd-resolve"
  "systemd-timesync"
  "mysql"
  "dbus"
  "rpc"
  "rpcuser"
  "haldaemon"
  "apache"
  "postfix"
  "gdm"
  "adiosl"
  "cubrid"
)


# sulog에서 su 명령을 통해 권한 상승 시도 확인 중

INFO "sulog에서 su 명령을 통해 권한 상승 시도 확인 중..."
if [ ! -f /var/log/sulog ]; then
  INFO "/var/log/sulog 파일을 찾을 수 없습니다"
else
  while read line; do
    user=$(echo $line | awk '{print $1}')
    if [[ ! " ${allowed_accounts[@]} " =~ " ${user} " ]]; then
      INFO "사용자별 권한 상승 시도: $user"
    else
      OK "권한 상승 시도가 없습니다."
    fi
  done < /var/log/sulog
fi

# 반복적인 로그인 실패에 관한 로그 검토

# 반복적인 로그인 실패에 대한 임계값 설정
threshold=5

# 로그 파일에서 반복되는 로그인 실패 횟수를 가져옵니다
count=$(grep -c "Failed password" /var/log/auth.log)

# 로그에서 반복적인 로그인 실패 여부 확인
INFO "로그에서 반복적인 로그인 실패를 확인하는 중..."
if [ ! -f /var/log/auth.log ]; then
  INFO "/var/log/auth.log 파일을 찾을 수 없습니다"
else
  if [ "$count" -gt "$threshold" ]; then
    WARN "반복적인 로그인 실패가 탐지되었습니다. 총 실패 수: $count"
  else
    OK "로그인 실패가 반복되지 않습니다. 총 실패 수: $count"
  fi
fi


# 로그인 거부에 관한 로그 검토

# 로그 파일 위치
LOG_FILE="/var/log/auth.log"

# 로그 파일에서 로그인 거부 메시지 검색
grep "authentication failure" $LOG_FILE




cat $result

echo ; echo


 
