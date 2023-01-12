#!/bin/bash

 

 

. function.sh

 
 TMP1=`SCRIPTNAME`.log

> $TMP1

BAR

CODE [U-04] 패스워드 파일 보호

cat << EOF >> $result

[양호]: 쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우

[취약]: 쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않는 경우

EOF

BAR


# Check if the shadow password file exists
if [ ! -f /etc/shadow ]; then
    WARN "쉐도우 패스워드 파일이 없습니다. 암호는 암호화되지 않고 저장되지 않습니다"
else
    OK "쉐도우 패스워드 파일이 있습니다. 암호는 섀도 암호를 사용하여 암호화되고 저장됩니다."
fi


 

 

cat $result

echo ; echo
