#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1  
 

BAR

CODE [U-58] 홈 디렉터리로 지정한 디렉터리의 존재 관리 

cat << EOF >> $result

[양호]: 홈 디렉터리가 존재하지 않는 계정이 발견되지 않는 경우

[취약]: 홈 디렉터리가 존재하지 않는 계정이 발견된 경우

EOF

BAR



# Set the target home directory path
home_dir="/home"

# Use the cat command to get the list of all accounts
accounts=$(cat /etc/passwd | cut -d':' -f1)

# Iterate through each account
for account in $accounts; do
  # Use the getent command to get the home directory of the account
  home_directory=$(getent passwd $account | cut -d':' -f6)

  # Check if the home directory exists
  if [ ! -d "$home_directory" ]; then
    OK "계정 $account 에 홈 디렉토리가 없습니다."
  else
    WARN "계정 $account 에 홈 디렉토리가 있습니다."
  fi
done


cat $TMP1

echo ; echo 

