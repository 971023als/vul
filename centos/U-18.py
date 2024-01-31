#!/bin/bash

. function.sh


TMP1=`SCRIPTNAME`.log

>$TMP1    

BAR

CODE [U-18] 접속 IP 및 포트 제한 

cat << EOF >> $result

[양호]: /etc/hosts.deny 파일에 ALL Deny 설정후

/etc/hosts.allow 파일에 접근을 허용할 특정 호스트를 등록한 경우

[취약]: 위와 같이 설정되지 않은 경우

EOF

BAR

 
CHECK1=$(cat /etc/hosts.allow | grep -v "^#")
CHECK2=$(cat /etc/hosts.deny | grep -v "^#")

if [ -n "$CHECK1" ] && [ -n "$CHECK2" ] ; then
	OK "접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정한 경우"	
else
	WARN "접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정하지 않은 경우"
fi

 

cat $result

echo ; echo


if nonexistent_device_files:
        results.append({
            "분류": "파일 및 디렉터리 관리",
            "코드": "U-18",
            "위험도": "상",
            "진단 항목": "접속 IP 및 포트 제한",
            "진단 결과": "취약",
            "현황": " /etc/hosts.deny 파일에 ALL Deny 설정후 /etc/hosts.allow 파일에 접근을 허용할 특정 호스트를 등록 안 한 경우",
            "대응방안": " /etc/hosts.deny 파일에 ALL Deny 설정후 /etc/hosts.allow 파일에 접근을 허용할 특정 호스트를 등록"
        })
    else:
        results.append({
            "분류": "파일 및 디렉터리 관리",
            "코드": "U-18",
            "위험도": "상",
            "진단 항목": "접속 IP 및 포트 제한",
            "진단 결과": "양호",
            "현황": " /etc/hosts.deny 파일에 ALL Deny 설정후 /etc/hosts.allow 파일에 접근을 허용할 특정 호스트를 등록한 경우",
            "대응방안": " /etc/hosts.deny 파일에 ALL Deny 설정후 /etc/hosts.allow 파일에 접근을 허용할 특정 호스트를 등록"
        })

return results