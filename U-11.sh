#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

>$TMP1 


BAR

CODE [U-11] /etc/syslog.conf 파일 소유자 및 권한 설정 

cat << EOF >> $result 

[양호]: /etc/syslog.conf 파일의 소유자가 root(또는 bin, sys)이고, 권한이 640 이하인 경우

[취약]: /etc/syslog.conf 파일의 소유자가 root(또는 bin, sys)가 아니거나, 권한이  640 이하가 아닌 경우

EOF

BAR



# Check the ownership of the file
file_owner=$(stat -c %U /etc/syslog.conf)
if [[ "$file_owner" != "root" && "$file_owner" != "bin" && "$file_owner" != "sys" ]]; then
  WARN "Error: /etc/syslog.conf가 루트(또는 bin, sys)에 의해 소유되지 않습니다."
fi

# Check the permissions of the file
file_perms=$(stat -c %a /etc/syslog.conf)
dec_perms=$(printf "%d" $file_perms)
if [ $dec_perms -lt 640 ]; then
    WARN "/etc/syslog.conf에 대한 사용 권한은 안전하지 않습니다"
else
    OK "/etc/syslog.conf에 대한 사용 권한은 안전합니다"
fi


# If the script reaches this point, the ownership and permissions are correct
OK "/etc/syslog.conff에 올바른 소유권 및 사용 권한이 있음"



cat $result

echo ; echo

 



 
