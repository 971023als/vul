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

ps_chk=`ps -ef | grep named | grep -v grep | wc -l`
ver_chk=`named -v 2>/dev/nill | awk -F " " '{print $2}' | awk -F "ubuntu" '{print $1}' | awk -F "-" '{print $1}' | tr -d "."`
inst_chk=`named -v 2>/dev/null | wc -l`
version=9113

#bind9 서비스가 설치되어있고 작동하는지 확인.
if [ $ps_chk != 0 ] && [ $inst_chk != 0 ];then

	#설정한 버전과 bind9 버전 비교
	if [ $ver_chk -lt $version ];then
		echo "[-] U33. Bind version is vulnerable, Result : Vul" 
	else
		echo "[+] U33. Bind version is very well, Result : Good"
	fi
else
	echo "[+] U33. Bind service disable, Result : Good"
fi



cat $result

echo ; echo