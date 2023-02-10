#!/bin/bash

. function.sh

BAR

CODE [U-13] SUID,SGID,Sticky bit 설정파일 점검 

cat << EOF >> $result

[양호]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우

[취약]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있는 경우

EOF

BAR

# SUID 또는 SGID 권한이 있는 모든 파일 찾기
output=$(find / -xdev -user root -type f \( -perm -04000 -o -perm -02000 \) -exec ls -al {} \;)

# 출력을 배열로 분할
arr=($output)

# 어레이를 순환하여 SUID 및 SGID 확인
for line in "${arr[@]}"
do
  if [[ $line == *"r-s"* ]]; then
    WARN "$line : SUID가 다음에 대해 설정됨"
  elif [[ $line == *"r-S"* ]]; then
    WARN "$line : SGID가 다음에 대해 설정됨"
  else
    OK "$line SUID와 SGID에 대한 설정이 부여"
  fi
done


cat $result

echo ; echo

 
