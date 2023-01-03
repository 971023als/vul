#!/bin/bash

 

. function.sh

 

TMP1=./log/`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-59] 숨겨진 파일 및 디렉터리 검색 및 제거

cat << EOF >> $RESULT

[양호]: 디렉터리 내 숨겨진 파일을 확인하여, 불필요한 파일 삭제를 완료한 경우

[취약]: 디렉터리 내 숨겨진 파일을 확인하지 않고, 불필요한 파일을 방치한 경우

EOF

BAR

 

find / -name '.*' > $TMP1

 

INFO "$TMP1 (숨김파일 목록) 파일 참고하시기 바랍니다. "

 

echo >>$RESULT

echo >>$RESULT

 
