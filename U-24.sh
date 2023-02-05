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
if [ ! -f "/etc/dfs/dfstab" ] && [ ! -f "/etc/exports" ]; then
  INFO "/etc/dfs/dfstab 또는 /etc/export를 찾을 수 없습니다."
fi

# 사용할 파일 설정
file="/etc/dfs/dfstab"
if [ ! -f "$file" ]; then
  file="/etc/exports"
fi

# 파일의 각 줄 읽기
while read -r line; do
  # 주석 및 빈 줄 건너뛰기
  [[ "$line" =~ ^#.*$ ]] && continue
  [[ -z "$line" ]] && continue

  # 공유 및 해당 옵션 가져오기
  share=$(echo "$line" | awk '{print $1}')
  options=$(echo "$line" | awk '{$1=""; print $0}')

  # 공유가 있는지 확인하십시오
  if [ ! -d "$share" ]; then
    INFO "'$share' 공유를 찾을 수 없습니다."
  fi

  # 옵션이 일치하는지 확인하십시오
  actual_options=$(stat -c "%A" "$share")
  if [ "$actual_options" != "$options" ]; then
    WARN " '$share' 공유에 대한 옵션이 일치하지 않습니다."
    INFO "예상: $options"
    INFO "Actual: $Actual_options"
  fi
done < "$file"

OK "모든 공유가 있고 해당 옵션이 일치합니다."

services=("nfsd" "statd" "mountd")

for service in "${services[@]}"; do
  status=$(systemctl is-active "$service")
  if [ "$status" != "inactive" ]; then
    WARN "서비스 '$service'가 중지되지 않았습니다."
  fi
done

OK "모든 NFS 서비스(nfsd, statd, mountd)가 중지됩니다."




 
cat $result

echo ; echo