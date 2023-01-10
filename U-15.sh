#!/bin/bash

 

. function.sh

 

TMP1=./log/`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-15] world writable 파일 점검

cat << EOF >> $RESULT

[양호]: world writable 파일이 존재하지 않거나, 존재 시 설정 이유를 확인하고 있는 경우

[취약]: world writable 파일이 존재하나 해당 설정 이유를 확인하고 있지 않은 경우

EOF

BAR

 

TMP2=$(mktemp)

 

#!/bin/bash

# 전역에서 쓸 수 있는 파일 검색
writable_files=$(find / -type f -perm -0002)

# 전역 쓰기 가능한 파일이 발견된 경우
if [ -n "$writable_files" ]
then
  # 전역 쓰기 가능 파일에 대한 사용 권한 수정
  find / -type f -perm -0002 -exec chmod o-w {} \;

  # 고정 파일 출력 목록
  echo "Fixed permissions for the following files:"
  echo "$writable_files"
else
  # 전역 쓰기 가능한 파일을 찾을 수 없습니다
  echo "No world-writable files found"
fi


 

echo >>$RESULT

echo >>$RESULT

 
