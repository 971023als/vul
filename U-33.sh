#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1  

BAR

CODE [U-33]  DNS 보안 버전 패치 

cat << EOF >> $result

[양호]: DNS 서비스를 사용하지 않거나 주기적으로 패치를 관리하고 있는 경우

[취약]: DNS 서비스를 사용하며 주기적으로 패치를 관리하고 있지 않는 경우


EOF

BAR

# Check if DNS service is running
if systemctl is-active --quiet named; then
  OK "DNS 서비스가 실행 중"
else
  WARN "DNS 서비스가 실행되고 있지 않습니다."
fi

# Check if automatic updates are enabled
if grep -q "APT::Periodic::Update-Package-Lists" /etc/apt/apt.conf.d/10periodic; then
  OK "자동 업데이트 사용"
else
  WARN "자동 업데이트가 활성화되지 않음"
fi

# Check if automatic security updates are enabled
if grep -q "APT::Periodic::Unattended-Upgrade" /etc/apt/apt.conf.d/50unattended-upgrades; then
  OK "자동 보안 업데이트 사용"
else
  WARN "자동 보안 업데이트가 활성화되지 않음"
fi



cat $result

echo ; echo