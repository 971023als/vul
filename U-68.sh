#!/bin/bash

 

. function.sh


TMP1=`SCRIPTNAME`.log

> $TMP1   

BAR

CODE [U-68] 로그온 시 경고 메시지 제공

cat << EOF >> $result

[양호]: 서버 및 Telnet 서비스에 로그온 메시지가 설정되어 있는 경우

[취약]: 서버 및 Telnet 서비스에 로그온 메시지가 설정되어 있지 않은 경우

EOF

BAR



# 서버에 로그온 메시지가 설정되지 않았는지 확인합니다
if [ ! -f /etc/motd ]; then
    WARN "로그온 메시지가 서버에 대해 설정되지 않았습니다."
else
    OK "로그온 메시지가 서버에 대해 설정되어 있습니다."
fi

# Telnet 서비스에 대해 로그온 메시지가 설정되지 않았는지 확인합니다
if [ ! -f /etc/issue.net ]; then
    WARN "로그온 메시지가 텔넷 서비스에 대해 설정되지 않았습니다."
else
    OK "로그온 메시지가 텔넷 서비스에 대해 설정되어 있습니다."
fi

# 로그온 메시지가 FTP 서비스에 대해 설정되지 않았는지 확인합니다
if [ ! -f /etc/ftpbanner ]; then
    WARN "로그온 메시지가 FTP 서비스에 대해 설정되지 않았습니다."
else
    OK "로그온 메시지가 FTP 서비스에 대해 설정되어 있습니다."
fi

# SMTP 서비스에 대해 로그온 메시지가 설정되지 않았는지 확인합니다
if [ ! -f /etc/postfix/smtpd_banner ]; then
    WARN "로그온 메시지가 SMTP 서비스에 대해 설정되지 않았습니다."
else
    OK "로그온 메시지가 SMTP 서비스에 대해 설정되어 있습니다."
fi

# DNS 서비스에 대해 로그온 메시지가 설정되지 않았는지 확인합니다
if [ ! -f /etc/named.conf ]; then
    WARN "로그온 메시지가 DNS 서비스에 대해 설정되지 않았습니다."
else
    OK "로그온 메시지가 DNS 서비스에 대해 설정되어 있습니다."
fi


cat $result

echo ; echo

 
