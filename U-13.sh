#!/bin/bash

 

. function.sh


TMP1=`SCRIPTNAME`.log

>$TMP1  

BAR

CODE [U-13] SUID,SGID,Sticky bit 설정파일 점검 

cat << EOF >> $result

[양호]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우

[취약]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있는 경우

EOF

BAR

# 주요 실행 파일을 배열에 저장
executables=(/bin/ping /usr/bin/passwd /usr/bin/sudo)

# 실행 파일 배열을 반복합니다
for exec in "${executables[@]}"; do
  # SUID 비트가 설정되어 있는지 확인합니다
  if [ -u "$exec" ]; then
    WARN "$exec에 SUID가 설정되어 있습니다."
  else 
    OK "$exec에 SUID가 설정이 안 되어 있습니다."
  fi

  # SGID 비트가 설정되어 있는지 확인합니다
  if [ -g "$exec" ]; then
    WARN "$exec에 SGID가 설정되어 있습니다."
  else 
    OK "$exec에 SGID가 설정이 안 되어 있습니다."
  fi
done





cat $result

echo ; echo

 
