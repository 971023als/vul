#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1  
 

BAR

CODE [U-60] ssh 원격접속 허용

cat << EOF >> $result

[양호]: 원격 접속 시 SSH 프로토콜을 사용하는 경우

[취약]: 원격 접속 시 Telnet, FTP 등 안전하지 않은 프로토콜을 사용하는 경우

EOF

BAR

 


# 로그 파일 경로 설정
log_file="/var/log/auth.log"

# 로그 파일이 있는지 확인하십시오
if [ ! -f $log_file ]; then
    OK "Auth log file is not found"
else
    # grep 명령을 사용하여 로그 파일에서 Telnet 또는 FTP 검색
    telnet_count=$(grep -E "telnetd" $log_file | wc -l)
    ftp_count=$(grep -E "ftpd" $log_file | wc -l)
    if [ $telnet_count -ne 0 ]; then
        INFO "Telnet 프로토콜 사용 $telnet_count times"
    fi
    if [ $ftp_count -ne 0 ]; then
        INFO "FTP 프로토콜 사용 $ftp_count times"
    fi
    if [ $telnet_count -eq 0 ] && [ $ftp_count -eq 0 ]; then
        WARN "안전하지 않은 프로토콜이 탐지되지 않음"
    fi
fi


cat $result

echo ; echo 
