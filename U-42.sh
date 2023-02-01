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

# 패치 로그 파일이 있는지 확인하십시오
if [ ! -f $log_file ]; then
    WARN "패치 로그 파일을 찾을 수 없습니다. 패치 관리가 수행되지 않을 수 있습니다."
else
    # 패치 로그 파일이 최근 30일 이내에 업데이트되었는지 확인하십시오
    if test $(find $log_file -mtime -30); then
        OK "패치 로그 파일이 최근 30일 이내에 업데이트되고 패치 관리가 수행됩니다"
    else
        WARN "패치 로그 파일이 최근 30일 이내에 업데이트되지 않아 패치 관리가 수행되지 않을 수 있습니다."
    fi

    # grep을 사용하여 확인하지 않고 패치 관련 내용 적용 여부 확인
    Result=$(grep -E "^[ \t]*Patch applied without checking" $log_file)

    if [ -n "$Result" ]; then
        INFO "패치 관련 내용은 확인 없이 적용, 확인하는 것이 좋다"
    fi
fi


cat $result

echo ; echo 

 
