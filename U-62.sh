#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-62] ftp 계정 shell 제한

cat << EOF >> $result

[양호]: ftp 계정에 /bin/false 쉘이 부여되어 있는 경우

[취약]: ftp 계정에 /bin/false 쉘이 부여되지 않 경우

EOF

BAR



#Use the getent command to get all ftp account 
ftp_users=$(getent passwd | grep -E "^ftp" | cut -d: -f1)

# Iterate through each ftp account
for user in $ftp_users; do
  # Use the getent command to get the shell of the ftp account
  shell=$(getent passwd $user | cut -d: -f7)

  # Check if the ftp account has a /bin/false shell
  if [ "$shell" != "/bin/false" ]; then
    OK "ftp 계정 $user에 /bin/false 셸이 없습니다"
  else
    WARN "ftp 계정 $user에 /bin/false 셸이 있습니다."
  fi
done



cat $result

echo ; echo 

 
