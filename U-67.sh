#!/bin/bash

 

. function.sh


TMP1=`SCRIPTNAME`.log

> $TMP1  

BAR

CODE [U-67] SNMP 서비스 Community String의 복잡성 설정

cat << EOF >> $result

[양호]: SNMP Community 이름이 public, private 이 아닌 경우

[취약]: SNMP Community 이름이 public, private 인 경우

EOF

BAR

snmpd_config_file="/path/to/snmpd.conf"

# Check if the snmpd.conf file exists
if [ ! -f $snmpd_config_file ]; then
  echo "snmpd.conf 파일이 없습니다. 확인해주세요."
  exit 1
fi

# Search for community names in the snmpd.conf file
communities=$(grep -E '^community' $snmpd_config_file | cut -d ' ' -f 2)

for community in $communities; do
  if [ $community == "public" ] || [ $community == "private" ]; then
    echo "Community name $community는 허용되지 않습니다."
    exit 1
  fi
done

echo "snmpd.conf 파일의 모든 커뮤니티 이름이 예상대로입니다."

cat $result

echo ; echo 
