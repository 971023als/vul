#!/bin/bash

 

. function.sh


TMP1=`SCRIPTNAME`.log

>$TMP1   

BAR

CODE [U-17] $HOME/.rhosts, hosts.equiv 사용 금지 

cat << EOF >> $result

[양호]: login, shell, exec 서비스를 사용하지 않거나 사용 시 아래와 같은 설정이 적용된 경우 

1. /etc/hosts.equiv 및 $HOME/.rhosts 파일 소유자가 root 또는, 해당 계정인 경우 

2. /etc/hosts.equiv 및 $HOME/.rhosts 파일 권한이 600 이하인 경우 

3. /etc/hosts.equiv 및 $HOME/.rhosts 파일 설정에 ‘+’ 설정이 없는 경우

[취약]: login, shell, exec 서비스를 사용하고, 위와 같은 설정이 적용되지 않은 경우 

EOF

BAR

TMP1=`SCRIPTNAME`.log

>$TMP1  


# /etc/hosts.equiv의 소유자를 확인하십시오
if [ "$(stat -c '%U' /etc/hosts.equiv)" != "root" ]; then
  WARN "/etc/messages.equiv 소유자가 루트가 아닙니다."
else
  OK "/etc/messages.equiv 소유자는 루트입니다."
fi

# /etc/hosts.equiv의 사용 권한을 확인합니다
if [ "$(stat -c '%a' /etc/hosts.equiv)" -gt 600 ]; then
  WARN "/etc/syslog.equiv 권한이 600보다 큽니다."
else
  OK "/etc/syslog.equiv 권한이 600보다 작거나 같습니다."
fi

# $HOME/.rhosts 소유자 확인
if [ "$(stat -c '%U' $HOME/.rhosts)" != "root" ]; then
  WARN "$HOME/.rhosts 소유자가 루트가 아닙니다."
else
  OK "$HOME/.rhosts 소유자는 루트입니다."
fi

# $HOME/.rhosts의 사용 권한 확인
if [ "$(stat -c '%a' $HOME/.rhosts)" -gt 600 ]; then
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
 
