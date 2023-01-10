#!/bin/bash

 

. function.sh

 

BAR

CODE [U-17] $HOME/.rhosts, hosts.equiv 사용 금지 

cat << EOF >> $RESULT

[양호]: login, shell, exec 서비스를 사용하지 않거나 사용 시 아래와 같은 설정이 적용된 경우 

1. /etc/hosts.equiv 및 $HOME/.rhosts 파일 소유자가 root 또는 해당 계정인 경우 

2. /etc/hosts.equiv 및 $HOME/.rhosts 파일 권한이 600 이하인 경우 

3. /etc/hosts.equiv 및 $HOME/.rhosts 파일 설정에 '+'설정이 없는 경우

[취약]: login, shell, exec 서비스를 사용하고, 위와 같은 설정이 적용되지 않은 경우 

EOF

BAR

 

HECK_FILE=/etc/hosts.equiv

CHOWN=$(ls -l /etc/hosts.equiv | awk '{print $3}')

CHECK_PERM=$(find /etc/hosts.equiv -type f -perm -600 -ls | grep -v rw-r--r-- | awk '{print $3}')

CHECK_PERM2=$(ls -l /etc/hosts.equiv | awk '{print $1}')

 

if [ -f $CHECK_FILE ] ; then

INFO "$CHECK_FILE 파일이 존재하며 소유자와 권한을 체크합니다."

if [ $CHOWN = 'root' ] ; then

OK "파일의 소유자가 root 입니다."

if [ $CHECK_PERM2 > 600 ] ; then

WARN "파일의 권한이 600 이상으로 되어 있습니다."

echo

echo "$CHECK_FILE 의 권한이 $CHECK_PERM2 으로 되어 있습니다." > $TMP1

INFO "권한 설정 상태는 $TMP1 파일에서 확인하세요."

else

OK "파일의 권한이 600 이하로 되어 있습니다."

fi

else

WARN "파일의 소유자가 root가 아닙니다."

fi

else

INFO "$CHECK_FILE 이 존재하지 않습니다."

fi


cat $RESULT

echo ; echo
 
