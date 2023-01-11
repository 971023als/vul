#!/bin/bash

 

. function.sh

 

BAR

CODE [U-15] world writable 파일 점검

cat << EOF >> $U15

[양호]: world writable 파일이 존재하지 않거나, 존재 시 설정 이유를 확인하고 있는 경우

[취약]: world writable 파일이 존재하나 해당 설정 이유를 확인하고 있지 않은 경우

EOF

BAR

 

search_dir="/path/to/search"

if [ -d "$search_dir" ]; then
    files=$(find "$search_dir" -type f -perm -0002)
    if [ -z "$files" ]; then
        OK "$search_dir 에서 전역 쓰기 가능 파일을 찾을 수 없습니다."
    else
        WARN " $search_dir 에서 찾은 전역 쓰기 가능 파일: "
        INFO "$files"
    fi
else
    INFO " $search_dir 디렉터리를 찾을 수 없습니다"
fi



 
cat $U15

echo ; echo

 
