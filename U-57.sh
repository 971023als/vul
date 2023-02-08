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

# /etc/passwd에서 홈 디렉토리 읽기
cat /etc/passwd | awk -F ':' '{print $6}' | while read home_dir; do
  # 홈 디렉토리의 소유권 및 사용 권한 가져오기
  ls -ld "$home_dir" | while read permissions owner group; do
    # 홈 디렉토리의 소유자가 사용자 이름과 일치하는지 확인합니다
    username=$(basename "$home_dir")
    if [ ! -f "$home_dir" ]; then
      INFO "$home_dir 을 찾을 수 없습니다."
    else
      if [ "$username" = "$owner" ]; then
        OK "홈 디렉토리 $home_dir 는 $username 이 소유하고 있습니다."
      else
        WARN "홈 디렉토리 $home_dir 가 $username 에 의해 소유되지 않습니다"
      fi

      # 다른 사용자에게 홈 디렉토리에 대한 쓰기 권한이 있는지 확인
      if [ ! "${permissions:6:3}" = "rwx" ]; then
        OK "다른 사용자에게 $home_dir 에 대한 쓰기 권한이 없습니다."
      else
        WARN "다른 사용자에게 $home_dir 에 대한 쓰기 권한이 있습니다."
      fi
    fi
  done
done

cat $result

echo ; echo 


 
