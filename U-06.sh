#!/bin/bash

 

. function.sh

 

TMP1=$(SCRIPTNAME).log

> $TMP1

 

BAR

CODE [U-06] 파일 및 디렉토리 소유자 설정

cat << EOF >> $result

[양호]: 소유자가 존재하지 않은 파일 및 디렉터리가 존재하지 않는 경우

[취약]: 소유자가 존재하지 않은 파일 및 디렉터리가 존재하는 경우

EOF

BAR


# Check if any files or directories without owners exist
no_owner_files=( $(find / -nouser 2>/dev/null) )
if [ ${#no_owner_files[@]} -eq 0 ]; then
    OK "소유자가 없는 파일 또는 디렉터리를 찾을 수 없습니다."
else
    WARN "소유자가 없는 파일 또는 디렉터리가 발견되었습니다:"
    for file in "${no_owner_files[@]}"
    do
        INFO "$file"
    done
fi


 
cat $result

echo ; echo
