#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1  

BAR

CODE [U-33]  DNS 보안 버전 패치 '확인 필요'

cat << EOF >> $result

[양호]: DNS 서비스를 사용하지 않거나 주기적으로 패치를 관리하고 있는 경우

[취약]: DNS 서비스를 사용하며 주기적으로 패치를 관리하고 있지 않는 경우


EOF

BAR


# Check if the DNS service is running
if ! systemctl is-active --quiet named; then
  WARN "Error: DNS 서비스가 실행되고 있지 않습니다."
fi

# Get the version of the currently running DNS service
version=$(named -v | awk '{print $4}')

# Check if the version is less than a specified minimum version
if [[ "$(printf '%s\n' "$version" "$minimum_version" | sort -V | head -n1)" == "$version" ]]; then
  WARN "Error: DNS 서비스(이름 지정) 버전이 최신 버전이 아닙니다. 설치된 버전: $version. 최소 허용 버전: $minimum_version"
fi

# Check if there are any available updates for the DNS service
updates=$(yum check-update bind)
if [ -n "$updates" ]; then
  WARN "Error: DNS 서비스에 사용할 수 있는 업데이트가 있습니다. 최신 패치로 업데이트하십시오"
fi

# If the script reaches this point, the DNS service is running and up to date
OK "DNS 서비스(이름 지정)가 실행 중이며 최신 상태입니다. 설치된 버전: $version"


cat $result

echo ; echo