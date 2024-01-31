#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

>$TMP1  

 

 

BAR

CODE [U-20] Anonymous FTP 비활성화

cat << EOF >> $result

[양호]: Anonymous FTP (익명 ftp) 접속을 차단한 경우

[취약]: Anonymous FTP (익명 ftp) 접속을 차단하지 않은 경우

EOF

BAR

ftp_account="ftp"

if cat /etc/passwd | grep -q "$ftp_account"; then
  WARN "FTP 계정이 /etc/passwd 파일에 있습니다."
else
  OK "FTP 계정이 /etc/passwd 파일에 없습니다."
fi



cat $result

echo ; echo

if nonexistent_device_files:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-20",
            "위험도": "상",
            "진단 항목": "Anonymous FTP 비활성화",
            "진단 결과": "취약",
            "현황": " Anonymous FTP 활성화 되어 있는 경우",
            "대응방안": " Anonymous FTP 비활성화"
        })
    else:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-20",
            "위험도": "상",
            "진단 항목": "Anonymous FTP 비활성화",
            "진단 결과": "양호",
            "현황": " Anonymous FTP 비활성화 되어 있는 경우",
            "대응방안": " Anonymous FTP 비활성화"
        })

return results