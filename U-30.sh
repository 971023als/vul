#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1
 
 

BAR

CODE [U-30] Sendmail 버전 점검

cat << EOF >> $result

[양호]: Sendmail 버전이 최신버전인 경우 

[취약]: Sendmail 버전이 최신버전이 아닌 경우

EOF

BAR

 

installed_version=$(sendmail -d0.1 -bv | head -n 1 | awk '{print $4}')
latest_version=$(curl -s https://www.sendmail.com/sm/open_source/download/ | grep -oP '(?<=Current version: )[^<]+')

if [ "$installed_version" != "$latest_version" ]; then
    WARN "Sendmail version $installed_version이 최신 버전 $latest_version이 아닙니다."
else
    OK "Sendmail version $installed_version이 최신 버전입니다"
fi


cat $result

echo ; echo
 
