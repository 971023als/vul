#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

> $TMP1

TMP2=/tmp/tmp2

> $TMP2

 

BAR

CODE [U-21] r 계열 서비스 비활성화

cat << EOF >> $result

[양호]: r 계열 서비스가 비활성화 되어 있는 경우

[취약]: r 계열 서비스가 활성화 되어 있는 경우

EOF

BAR


CHECK1=$(ls -alL /etc/xinetd.d/* | egrep 'rsh|rlogin|rexec' | egrep -v 'grep|klogin|kshell|kexec' | wc -l)
CHECK2=$(ls -alL /etc/xinetd.d/* | egrep 'rsh|rlogin|rexec' | egrep -v 'grep|klogin|kshell|kexec' |awk '{print $NF}' >> /root/linuxs/U-21.txt)

FILE1=$(cat U-21.txt | sed -n '1p')
FILE2=$(cat U-21.txt | sed -n '2p')
FILE3=$(cat U-21.txt | sed -n '3p')

FILECHECK1=$(cat $FILE1 | grep disable | awk '{print $3}')
FILECHECK2=$(cat $FILE2 | grep disable | awk '{print $3}')
FILECHECK3=$(cat $FILE3 | grep disable | awk '{print $3}')

if [ $CHECK1 != 0 ] ; then
	if [ $FILECHECK1 == 'yes' ] && [ $FILECHECK2 == 'yes' ] && [ $FILECHECK3 == 'yes' ] ; then
		OK "불필요한 r 계열 서비스가 비활성화 되어 있는 경우"
	else
		WARN "불필요한 r 계열 서비스가 활성화 되어 있는 경우"
	fi
else
	OK "불필요한 r 계열 서비스가 비활성화 되어 있는 경우"
fi

cat $result

echo ; echo