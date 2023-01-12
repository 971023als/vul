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


# Check the ownership of the /etc/hosts.equiv file
file_owner=$(stat -c %U /etc/hosts.equiv)
if [[ "$file_owner" != "root" && "$file_owner" != "$(whoami)" ]]; then
  WARN "Error: /etc/hosts.equiv가 루트 또는 $(woami)에 의해 소유되지 않습니다."
fi

# Check the permissions of the /etc/hosts.equiv file
file_perms=$(stat -c %a /etc/hosts.equiv)
if [ "$file_perms" -gt 600 ]; then
  WARN "Error: /etc/hosts.equiv에 잘못된 사용 권한이 있습니다. 600 이하여야 합니다."
fi

# Check if the /etc/hosts.equiv file contains the '+' setting
if ! grep -q "+" /etc/hosts.equiv; then
  WARN "Error: /etc/hosts.equiv에 '+' 설정이 없습니다."
fi

# Check the ownership of the $HOME/.rhosts file
file_owner=$(stat -c %U $HOME/.rhosts)
if [[ "$file_owner" != "root" && "$file_owner" != "$(whoami)" ]]; then
  WARN "Error: $HOME/.rhosts가 루트 또는 $(woami)에 의해 소유되지 않습니다." 
fi

# Check the permissions of the $HOME/.rhosts file
file_perms=$(stat -c %a $HOME/.rhosts)
if [ "$file_perms" -gt 600 ]; then
  WARN "Error: $HOME/.rhosts에 잘못된 권한이 있습니다. 600 이하여야 합니다."
fi

# Check if the $HOME/.rhosts file contains the '+' setting
if ! grep -q "+" $HOME/.rhosts; then
  WARN "Error: $HOME/.rhosts에 '+' 설정이 없습니다"
fi

# If the script reaches this point, the ownership, permissions, and the '+' setting are correct
OK "/etc/hosts.equiv 및 $HOME/.rhosts에 올바른 소유권, 사용 권한 및 '+' 설정이 있습니다."


 




cat $result

echo ; echo
 
