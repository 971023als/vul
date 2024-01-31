#!/bin/bash

. function.sh

 

BAR

CODE [U-29] tftp, talk 서비스 비활성화

cat << EOF >> $result

[양호]: tftp, talk, ntalk 서비스가 비활성화 되어 있는 경우

[취약]: tftp, talk, ntalk 서비스가 활성화 되어 있는 경우

EOF

BAR


services="tftp talk ntalk"

for service in $services
do
    if systemctl is-enabled $service >/dev/null 2>&1; then
        WARN "$service 서비스가 사용하는 중입니다."
    else
        OK "$service 서비스가 사용하는 중입니다."
    fi
done


cat $result

echo ; echo
 

if nonexistent_device_files:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-29",
            "위험도": "상",
            "진단 항목": "tftp, talk 서비스 비활성화",
            "진단 결과": "취약",
            "현황": "tftp, talk, ntalk 데몬이 활성화되어 있거나 xinetd(인터넷슈퍼데몬)에 존재하는 상태",
            "대응방안": "tftp, talk, ntalk 데몬이 비활성화되어 있고 xinetd(인터넷슈퍼데몬) 비활성화"
        })
    else:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-29",
            "위험도": "상",
            "진단 항목": "tftp, talk 서비스 비활성화",
            "진단 결과": "양호",
            "현황": "tftp, talk, ntalk 데몬이 비활성화되어 있고 xinetd(인터넷슈퍼데몬)에 존재하지 않는 상태",
            "대응방안": "tftp, talk, ntalk 데몬이 비활성화되어 있고 xinetd(인터넷슈퍼데몬) 비활성화"
        })

return results