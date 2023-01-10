#!/bin/bash

. function.sh

TMP1=`SCRIPTNAME`.log

>$TMP1

BAR

CODE [U-07] /etc/passwd 파일 소유자 및 권한 설정

cat << EOF >> $RESULT

[ 양호 ] : /etc/passwd 파일의 소유자가 root이고, 권한이 644 이하인 경우

[ 취약 ] : /etc/passwd 파일의 소유자가 root가 아니거나, 권한이 644 이하가 아닌 경우

EOF

BAR

 

CHECK_FILE=/etc/passwd

CHOWN=$(ls -l /etc/passwd | awk '{print $3}')

CHECK_PERM=$(find /etc/passwd -type f -perm -644 -ls | grep -v rw-r--r-- | awk '{print $3}')

CHECK_PERM2=$(ls -l /etc/passwd | awk '{print $1}')


 
if [ -f $CHECK_FILE ] ; then

INFO "$CHECK_FILE 파일이 존재하며 소유자와 권한을 체크합니다."

# Check permissions and ownership of /etc/passwd
permissions=$(stat -c "%a" /etc/passwd)
if [ $permissions -le 644 ]
then
  echo "/etc/passwd에 적절한 권한이 있음"
else
  echo "/etc/passwd에 잘못된 사용 권한이 있습니다"
fi

owner=$(ls -l /etc/passwd | awk '{print $3}')
if [ $owner == "root" ]
then
  echo "/etc/passwd는 root에 의해 소유됩니다"
else
  echo "/etc/passwd가 루트에 의해 소유되지 않음"
fi



echo

echo "$CHECK_FILE 의 권한이 $CHECK_PERM2 으로 되어 있습니다." > $TMP1

INFO "권한 설정 상태는 $TMP1 파일에서 확인하세요."

else

INFO "$CHECK_FILE 이 존재하지 않습니다."

fi

cat $RESULT

echo ; echo
