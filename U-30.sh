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


# Get the installed version of Sendmail
installed_version=`dpkg-query -W -f='${Version}' sendmail`

# Get the latest version of Sendmail from the Ubuntu package repository
latest_version=`apt-cache policy sendmail | grep "Candidate" | awk '{print $2}'`

# Compare the installed version with the latest version
if [[ "$installed_version" < "$latest_version" ]]; then
  WARN "Sendmail이 최신 버전이 아닙니다. 설치된 버전: $installed_version 최신 버전: $latest_version"
else
  OK "Sendmail이 최신 상태입니다. 설치된 버전: $installed_version 최신 버전: $latest_version"
fi


cat $result

echo ; echo
 
