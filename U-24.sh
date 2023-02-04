#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1 

 

BAR

CODE [U-24] NFS 서비스 비활성화 

cat << EOF >> $result

[양호]: 불필요한 NFS 서비스가 비활성화 되어있는 경우

[취약]: 불필요한 NFS 서비스가 활성화 되어있는 경우

EOF

BAR

# 파일이 있는지 확인하십시오
if [ -f "/etc/dfs/dfstab" ]; then
  shares_file="/etc/dfs/dfstab"
elif [ -f "/etc/exports" ]; then
  shares_file="/etc/exports"
else
  INFO "공유 파일을 찾을 수 없습니다."
fi

# 파일에서 공유 목록 가져오기
shares=$(grep '^share' $shares_file | awk '{print $2}')

# 각 공유가 있는지 확인합니다
for share in $shares; do
  if [ -d "$share" ]; then
    WARN "$share가 있습니다."
  else
    OK "$share가 없습니다."
  fi
done

services=("nfsd" "statd" "mountd")

for service in "${services[@]}"; do
  status=$(systemctl is-active "$service")
  if [ "$status" == "active" ]; then
    WARN "$service가 실행 중입니다."
  elif [ "$status" == "inactive" ]; then
    OK "$service가 중지되었습니다."
  else
    INFO "$service의 상태를 확인할 수 없습니다."
  fi
done



 
cat $result

echo ; echo