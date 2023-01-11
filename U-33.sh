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


installed_version=$(named -v | awk '{print $3}')
latest_version=$(curl -s https://www.isc.org/downloads/ | grep -oP '(?<=BIND<\/a><\/td><td class="version">)[^<]+')

if [ "$installed_version" != "$latest_version" ]; then
    WARN "최신 버전 $installed_version이 최신 버전 $timeout_version이 아닙니다."
else
    OK "최신 버전 $installed_version이 최신 버전입니다"
fi

patch_count=$(yum list --security bind | grep "bind" | awk '{print $1}' | wc -l)

if [ $patch_count -gt 0 ]; then
    WARN "바인드에 사용할 수 있는 패치가 $patch_count 있습니다."
else
    OK "바인드에 사용할 수 있는 패치가 없습니다."
fi

cat $result

echo ; echo