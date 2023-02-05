#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

>$TMP1

 

 

BAR

CODE [U-09] /etc/hosts 파일 소유자 및 권한 설정.

cat << EOF >> $result

[양호]: /etc/hosts 파일의 소유자가 root이고, 권한이 600 이하경우

[취약]: /etc/hosts 파일의 소유자가 root가 아니거나, 권한이 600 이상인 경우

EOF

BAR

file="/etc/hosts"

# Check ownership
owner=$(stat -c '%U' "$file")
if [ "$owner" != "root" ]; then
  echo "ERROR: The owner of $file is not root. It is owned by $owner."
else
  echo "The owner of $file is root."
fi

# Check permissions
permissions=$(stat -c '%a' "$file")
if [ "$permissions" -lt 600 ]; then
  echo "ERROR: The permissions of $file are less than 600. They are set to $permissions."
else
  echo "The permissions of $file are at least 600."
fi



cat $result

echo ; echo
