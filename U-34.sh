#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-34] DNS Zone Transfer 설정

cat << EOF >> $U34

[양호]: DNS 서비스 미사용 또는, Zone Transfer를 허가된 사용자에게만 허용한 경우

[취약]: DNS 서비스를 사용하여 Zone Transfer를 모든 사용자에게 허용한 경우

EOF

BAR


DOMAIN=example.com

# Use nslookup to check if zone transfer is allowed
nslookup -q=axfr $DOMAIN | grep -q "Transfer failed"
if [ $? -eq 0 ]; then
    echo "Zone transfer is not allowed for $DOMAIN"
else
    echo "Zone transfer is allowed for $DOMAIN"
fi


cat $U34

echo ; echo