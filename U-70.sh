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

# Path to Postfix main configuration file
CONF_FILE=/etc/postfix/main.cf

# Check if 'smtpd_recipient_restrictions' is present in configuration file
if grep -q "smtpd_recipient_restrictions" "$CONF_FILE"; then
  # Check if 'noexpn' and 'novrfy' are not present
  if ! grep -q "noexpn" "$CONF_FILE" && ! grep -q "novrfy" "$CONF_FILE"; then
    WARN "noexpn 및 novrfy 옵션이 설정되지 않았습니다."
  else
    WARN "noexpn 및 novrfy 옵션이 설정되었습니다."
  fi
else
  OK "구성 파일에서 esxd_disclusions를 찾을 수 없습니다."
fi



    

cat $result

echo ; echo 
