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

# /etc/passwd의 각 줄 읽기
while read line; do
  # 구분 기호로 ':'를 사용하여 줄을 필드로 분할
  fields=($(echo $line | tr ':' ' '))
  username=${fields[0]}
  home_dir=${fields[5]}
  owner=$(ls -ld "$home_dir" | awk '{print $3}')

  # 홈 디렉토리 소유자가 사용자 이름과 일치하는지 확인합니다
  if [ "$owner" != "$username" ]; then
    WARN "$home_dir owner($owner)가 사용자 이름($username)과(와) 일치하지 않습니다"
  else
    OK "$home_dir owner($owner)가 사용자 이름($username)과(와) 일치합니다"
  fi
done < /etc/passwd

# 다른 사용자에 대한 쓰기 권한 확인
permissions=$(stat -c "%a" "$home_dir")
other_write=${permissions:2:1}
if [ "$other_write" == "w" ]; then
  WARN "다른 사용자에게 $home_dir 에 대한 쓰기 권한이 있습니다."
else
  OK "다른 사용자에게 $home_dir 에 대한 쓰기 권한이 없습니다."
fi


cat $result

echo ; echo 


 
