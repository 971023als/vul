#!/bin/bash

 

. function.sh

 

BAR

CODE [U-15] world writable 파일 점검

cat << EOF >> $RESULT

[양호]: world writable 파일이 존재하지 않거나, 존재 시 설정 이유를 확인하고 있는 경우

[취약]: world writable 파일이 존재하나 해당 설정 이유를 확인하고 있지 않은 경우

EOF

BAR

 


# 전역에서 쓸 수 있는 파일 검색
writable_files=$(find / ! \( -path '/proc*' -o -path '/sys/fs*' -o -path '/usr/local*' -prune \) -perm -2 -type f -exec ls -al {} \;)

# 전역 쓰기 가능한 파일이 발견된 경우
if [ -n "$writable_files" ] ; then
  # 고정 파일 출력 목록
  WARN  "전역 쓰기 가능한 파일을 찾았습니다:"
  INFO  "$writable_files"
else
  # 전역 쓰기 가능한 파일을 찾을 수 없습니다
  OK  "전역 쓰기 가능한 파일을 찾을 수 없습니다"
fi


 
cat $RESULT

echo ; echo

 
