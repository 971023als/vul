#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1
 

BAR

CODE [U-28] NIS, NIS+ 점검 

cat << EOF >> $result

[양호]: NIS 서비스가 비활성화 되어 있거나. 필요 시 NIS+를 사용하는 경우

[취약]: NIS 서비스가 활성화 되어 있는 경우

EOF

BAR


TMP=$(mktemp)
ps -ef | egrep "ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated" | grep -v grep | awk '{print $2,$6}' > "$TMP"

if [ -s "$TMP" ] ; then
    while read PID PROCESS
    do
        WARN "$PID / $PROCESS가 실행 중입니다."
    done < "$TMP"
else
    OK "NIS 서비스가 비활성화되었습니다."
fi


cat $result

echo ; echo

if nonexistent_device_files:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-28",
            "위험도": "상",
            "진단 항목": "NIS , NIS+ 점검",
            "진단 결과": "취약",
            "현황": "안전하지 않은 NIS. NIS+ 관련 데몬이 활성화되어 있는 상태",
            "대응방안": "안전하지 않은 NIS. NIS+ 관련 데몬이 비활성화"
        })
    else:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-28",
            "위험도": "상",
            "진단 항목": "NIS , NIS+ 점검",
            "진단 결과": "양호",
            "현황": "안전하지 않은 NIS. NIS+ 관련 데몬이 비활성화되어 있는 상태",
            "대응방안": "안전하지 않은 NIS. NIS+ 관련 데몬이 비활성화"
        })

return results