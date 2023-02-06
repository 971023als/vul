#!/bin/bash

 

. function.sh


TMP1=`SCRIPTNAME`.log

>$TMP1   

BAR

CODE [U-17] $HOME/.rhosts, hosts.equiv 사용 금지 

cat << EOF >> $result

[양호]: login, shell, exec 서비스를 사용하지 않거나 사용 시 아래와 같은 설정이 적용된 경우 

1. /etc/hosts.equiv 및 $HOME/.rhosts 파일 소유자가 root 또는, 해당 계정인 경우 

2. /etc/hosts.equiv 및 $HOME/.rhosts 파일 권한이 600 미만인 경우 

3. /etc/hosts.equiv 및 $HOME/.rhosts 파일 설정에 ‘+’ 설정이 없는 경우

[취약]: login, shell, exec 서비스를 사용하고, 위와 같은 설정이 적용되지 않은 경우 

EOF

BAR

# /etc/hosts.equiv의 소유자를 확인합니다
FILE="/etc/hosts.equiv"

if [ -f "$FILE" ]; then
  OWNER=$(stat -c '%U' "$FILE")
  if [ "$OWNER" == "root" ]; then
    OK "예상대로 $FILE의 소유자는 루트입니다."
else
  WARN "$FILE 의 소유자는 $OWNER 이지만 루트여야 합니다."
  fi
else
  INFO "$FILE 이 없습니다."
fi


# /etc/hosts.equiv의 사용 권한을 확인합니다
HOSTS_EQUIV_PERM=$(stat -c '%a' /etc/hosts.equiv)
if [ "$HOSTS_EQUIV_PERM" -gt 600 ] 2>/dev/null; then
  WARN "/etc/syslog.equiv 권한이 600보다 큽니다."
else
  OK "/etc/syslog.equiv 권한이 600보다 작거나 같습니다."
fi

# $HOME/.rhosts의 소유자를 확인합니다
RHOSTS_FILE=$HOME/.rhosts
if [ -f $RHOSTS_FILE ]; then
  RHOSTS_OWNER=$(ls -l $RHOSTS_FILE | awk '{print $3}')
  if [ $RHOSTS_OWNER == "root" ]; then
    OK "예상대로 $RHOSTS_FILE 의 소유자는 루트입니다."
else
  WARN "$RHOSTS_FILE 의 소유자는 $RHOSTS_OWNER 이지만 루트여야 합니다."
  fi
else
  INFO "$RHOSTS_FILE 이 없습니다."
fi
fi


# $HOME/.rhosts의 사용 권한 확인
RHOSTS_PERM=$(stat -c '%a' $HOME/.rhosts)
if [ "$RHOSTS_PERM" -gt 600 ] 2>/dev/null; then
  WARN "$HOME/.rhosts 권한이 600보다 큽니다."
else
  OK "$HOME/.rhosts 권한이 600보다 작거나 같습니다."
fi

# /etc/hosts.equiv 또는 $HOME/.rhosts에 '+' 설정이 있는지 확인하십시오
if grep -q '^\+' /etc/hosts.equiv || grep -q '^\+' $HOME/.rhosts; then
  WARN "File /etc/hosts.equiv 또는 $HOME/.rhosts에 '+' 설정이 있습니다."
else
  OK "File /etc/hosts.equiv 및 $HOME/.rhosts에 '+' 설정이 없습니다."
fi


cat $result

echo ; echo
 
