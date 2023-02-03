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


# 대상 홈 디렉토리 경로 설정
home_dir="/home"

# find 명령을 사용하여 홈 디렉토리 경로 가져오기
home_directories=$(find $home_dir -mindepth 1 -maxdepth 1 -type d)

# 각 홈 디렉토리를 반복합니다
for directory in $home_directories; do
  # stat 명령을 사용하여 디렉토리의 소유자 및 그룹 가져오기
  owner=$(stat -c %U $directory)
  group=$(stat -c %G $directory)

  # stat 명령을 사용하여 디렉토리의 소유자 및 그룹 가져오기
  id_result=$(id -nG $owner | grep $group)

  # 소유자가 그룹의 구성원인지 확인하고 그룹에 쓰기 권한이 있는지 확인합니다
  if [ -z "$id_result" ] && [ $(find $directory -perm -002 -type d -print | wc -l) -gt 0 ]; then
    WARN "홈 디렉토리 $directory는 계정에 의해 소유되지 않으며 다른 사용자에게 쓸 수 있는 권한이 있습니다."
  else
    OK "홈 디렉토리 $directory는 계정에 의해 소유되어 있으며 다른 사용자에게 쓸 수 있는 권한이 없습니다."
  fi
done



cat $result

echo ; echo 


 
