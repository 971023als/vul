#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1   
 

BAR

CODE [U-70] expn, vrfy 명령어 제한

cat << EOF >> $result

[양호]: SMTP 서비스 미사용 또는, noexpn, novrfy 옵션이 설정되어 있는 경우

[취약]: SMTP 서비스 사용하고, noexpn, novrfy 옵션이 설정되어 있지 않는 경우

EOF

BAR


# Check if the SMTP service is running
service=`systemctl is-active postfix`
if [ $service != "active" ]; then
  INFO "SMTP 서비스가 실행되고 있지 않습니다."
fi

# Check if the noexpn and novrfy options are set
options=`postconf | grep "smtpd_discard_ehlo_keywords"`
if [ -z "$options" ]; then
  WARN "noexpn 및 novrfy 옵션이 설정되지 않았습니다."
fi

OK "SMTP 서비스가 실행 중이고 noexpn, novrfy 옵션이 설정되었습니다."


    

cat $result

echo ; echo 
