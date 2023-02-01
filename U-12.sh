#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

>$TMP1  

BAR

CODE [U-12] /etc/services 파일 소유자 및 권한 설정 

cat << EOF >> $result  

[양호]: /etc/services 파일의 소유자가 root이고, 권한이 644인 경우

[취약]: /etc/services 파일의 소유자가 root가 아니거나, 권한이 644가 아닌경우

EOF

BAR


# 파일이 root, bin 또는 sys에 의해 소유되지 않는지 확인합니다
if [ $(stat -c "%U" /etc/services) == "root" ] || [ $(stat -c "%U" /etc/services) == "bin" ] || [ $(stat -c "%U" /etc/services) == "sys" ]; then
    WARN "/etc/services 파일은 루트 또는 bin 또는 sys에 의해 소유됩니다."
fi

# 파일 사용 권한이 644가 아닌지 확인하십시오
if [ $(stat -c "%a" /etc/services) -gt 644 ]; then
    WARN "/etc/services 파일의 권한이 644보다 큽니다."
fi

OK "/etc/services 파일이 루트 또는 bin 또는 sys에 의해 소유되지 않으며 644 이하의 권한이 있습니다."


cat $result

echo ; echo
