#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

> $TMP1

 

 

BAR

CODE [U-49] 불필요한 계정 제거

cat << EOF >> $result

[양호]: 불필요한 계정이 존재하지 않는 경우

[취약]: 불필요한 계정이 존재하는 경우

EOF

BAR

# 승인된 계정 목록
approved_accounts=(
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

# 모든 계정에 반복
for account in $(cut -d: -f1 /etc/passwd); do
  # 계정이 승인 목록에 없는지 확인하십시오
  if ! echo "${approved_accounts[@]}" | grep -qw "$account"; then
    WARN "오류: 승인되지 않은 계정 '$account'이(가) 있습니다."
  else
    OK "모든 계정이 승인되었습니다."
  fi
done

 

 

cat $result

echo ; echo
