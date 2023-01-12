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


# Get the current version of Sendmail
version=$(sendmail -d0.1 -bv | grep "^Version" | awk '{print $2}')

# Check if the version is less than a specified minimum version
if [[ "$(printf '%s\n' "$version" "$minimum_version" | sort -V | head -n1)" == "$version" ]]; then
  WARN "Error: 발송 메일 버전이 최신 버전이 아닙니다. 설치된 버전: $version. 최소 허용 버전: $minimum_version"
fi

# If the script reaches this point, the version is up to date
OK "Sendmail 버전이 최신입니다. 설치된 버전: $version"



cat $result

echo ; echo
 
