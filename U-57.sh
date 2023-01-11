#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1  

 

BAR

CODE [U-57] 홈 디렉터리 소유자 및 권한

cat << EOF >> $result

[양호]: 홈 디렉터리 소유자가 해당 계정이고, 일반 사용자 쓰기 권한이 제거된 경우

[취약]: 홈 디렉터리 소유자가 해당 계정이 아니고, 일반 사용자 쓰기 권한이 부여된 경우 

EOF

BAR


# Set the target home directory path
home_dir="/home"

# Use find command to get the home directory paths
home_directories=$(find $home_dir -mindepth 1 -maxdepth 1 -type d)

# Iterate through each home directory
for directory in $home_directories; do
  # Use stat command to get the owner and group of the directory
  owner=$(stat -c %U $directory)
  group=$(stat -c %G $directory)

  # Use id command to check if the owner is a member of the group
  id_result=$(id -nG $owner | grep $group)

  # Check if the owner is a member of the group and check if the group has write permission
  if [ -z "$id_result" ] && [ $(find $directory -perm -002 -type d -print | wc -l) -gt 0 ]; then
    WARN "홈 디렉토리 $directory는 계정에 의해 소유되지 않으며 다른 사용자에게 쓸 수 있는 권한이 있습니다."
  else
    OK "홈 디렉토리 $directory는 계정에 의해 소유되어 있으며 다른 사용자에게 쓸 수 있는 권한이 없습니다."
  fi
done



cat $TMP1

echo ; echo 


 
