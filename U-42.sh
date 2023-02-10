#!/bin/bash

. function.sh
 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 
BAR

CODE [U-42] 최신 보안패치 및 벤더 권고사항 적용

cat << EOF >> $result

[양호]: 패치 적용 정책을 수립하여 주기적으로 패치를 관리하고 있는 경우

[취약]: 패치 적용 정책을 수립하지 않고 주기적으로 패치관리를 하지 않는 경우

EOF

BAR

# 로그 파일 경로 설정
log_file="/var/log/patch.log"

# 로그 파일이 있는지 확인하십시오
if [ -f $log_file ]; then
  WARN "패치 로그 파일 $log_file 이 존재하지 않습니다"
else
  OK "패치 로그 파일 $log_file 이 존재합니다"
fi


cat $result

echo ; echo 

 
