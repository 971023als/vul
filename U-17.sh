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


# /etc/hosts.equiv 파일의 소유권을 확인합니다
file_owner=$(stat -c %U /etc/hosts.equiv)
if [[ "$file_owner" != "root" && "$file_owner" != "$(whoami)" ]]; then
  WARN " /etc/hosts.equiv가 루트 또는 $(whoami)에 의해 소유되지 않습니다."
else
  OK " /etc/hosts.equiv가 루트 또는 $(whoami)에 의해 소유되었습니다."
fi

# /etc/hosts.equiv 파일의 권한을 확인합니다
file_perms=$(stat -c %a /etc/hosts.equiv)
dec_perms=$(printf "%d" $file_perms)
if [ $dec_perms -gt 600 ]; then
  WARN " /etc/hosts.equiv에 잘못된 사용 권한이 있습니다. 600 이하여야 합니다."
else
  OK " /etc/hosts.equiv에 올바른 사용 권한이 있습니다. 600 이상 입니다."
fi


# /etc/hosts.equiv 파일에 '+' 설정이 포함되어 있는지 확인하십시오
if ! grep -q "+" /etc/hosts.equiv; then
  WARN " /etc/hosts.equiv에 '+' 설정이 없습니다."
else
  OK " /etc/hosts.equiv에 '+' 설정이 있습니다."
fi

# $HOME/.rhosts 파일의 소유권을 확인합니다
file_owner=$(stat -c %U $HOME/.rhosts)
if [[ "$file_owner" != "root" && "$file_owner" != "$(whoami)" ]]; then
  WARN " $HOME/.rhosts가 루트 또는 $(whoami)에 의해 소유되지 않습니다."
else
  OK "  $HOME/.rhosts가 루트 또는 $(whoami)에 의해 소유되었습니다." 
fi

# $HOME/.rhosts 파일의 권한을 확인합니다
file_perms=$(stat -c %a $HOME/.rhosts)
dec_perms=$(printf "%d" $file_perms)
if [ $dec_perms -gt 600 ]; then
  WARN " $HOME/.rhosts에 잘못된 권한이 있습니다. 600 이하여야 합니다."
else
  OK " $HOME/.rhosts에 올바른 사용 권한이 있습니다. 600 이상 입니다."
fi

# $HOME/.rhosts 파일에 '+' 설정이 포함되어 있는지 확인하십시오
if ! grep -q "+" $HOME/.rhosts; then
  WARN " $HOME/.rhosts에 '+' 설정이 없습니다"
else
  OK " $HOME/.rhosts에 '+' 설정이 있습니다."
fi

# 스크립트가 이 지점에 도달하면 소유권, 사용 권한 및 '+' 설정이 올바른 것입니다
OK "/etc/hosts.equiv 및 $HOME/.rhosts에 올바른 소유권, 사용 권한 및 '+' 설정이 있습니다."


 




cat $result

echo ; echo
 
