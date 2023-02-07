#!/bin/bash

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-37] Apache 상위 디렉터리 접근 금지 

cat << EOF >> $result

[양호]: 상위 디렉터리에 이동제한을 설정한 경우

[취약]: 상위 디렉터리에 이동제한을 설정하지 않은 경우

EOF

BAR

# grep을 사용하여 apache2.conf 파일에서 AllowOrideAuthConfig 지시문을 검색합니다
result=$(grep -F "AllowOverride AuthConfig" /etc/apache2/apache2.conf )

# 결과가 비어 있지 않은지 확인하십시오
if [ -n "$result" ]; then
  OK "AllowOverride AuthConfig가 apache2.conf 파일에 설정되어 있습니다."
else
  WARN "AllowOverride AuthConfig가 apache2.conf 파일에 설정되어 있지 않습니다."
fi


cat $result

echo ; echo

 

 

