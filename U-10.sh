#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

>$TMP1

BAR

CODE [U-10] /etc/xinetd.conf 파일 소유자 및 권한 설정 

cat << EOF >> $result

[양호]: /etc/inetd.conf 파일의 소유자가 root이고, 권한이 600인 경우

[취약]: /etc/inetd.conf 파일의 소유자가 root가 아니거나, 권한이 600이 아닌 경우

EOF

BAR



# Check the ownership of the file
file_owner=$(stat -c %U /etc/inetd.conf)
if [ "$file_owner" != "root" ]; then
  WARN "Error: /etc/inetd.conf가 루트에 의해 소유되지 않음"
fi

# Check the permissions of the file
file_perms=$(stat -c %a /etc/inetd.conf)
if [ "$file_perms" != "600" ]; then
  WARN "Error: /etc/inetd.conf에 잘못된 사용 권한이 있습니다. 600이어야 합니다"
fi

# If the script reaches this point, the ownership and permissions are correct
OK "/etc/inetd.conf에 올바른 소유권 및 사용 권한이 있음"



cat $result

echo ; echo
 
