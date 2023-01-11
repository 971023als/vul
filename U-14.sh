#!/bin/bash

 

. function.sh

 

BAR

CODE [U-14] 사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정 

cat << EOF >> $RESULT

[양호]: 홈 디렉터리 환경변수 파일 소유자가 root 또는 해당 계정으로 지정되어 있고 

홈 디렉터리 환경변수 파일에 root와 소유자만 쓰기 권한이 부여된 경우

[취약]: 홈 디렉터리 환경변수 파일 소유자가 root 또는 해당 계정으로 지정되지 않고 

홈 디렉터리 환경변수 파일에 root와 소유자 외에 쓰기 권한이 부여된 경우

EOF

BAR

 


file=$(eval echo ~)/.*profile

if [ -f "$file" ]; then
    owner=$(ls -l "$file" | awk '{print $3}')
    permissions=$(ls -l "$file" | awk '{print $1}')
    if [ "$owner" = "root" ] && [ "$permissions" = "-rw-------" ]; then
        OK "$file 의 소유자 및 권한이 올바르게 설정되어 있습니다.."
    else
        WARN "$file 의 소유자 또는 권한이 잘못되었습니다"
    fi
else
    INFO "$file 을 찾을 수 없습니다."
fi

cat $RESULT

echo ; echo
 
