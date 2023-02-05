#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

>$TMP1  
 

BAR

CODE [U-14] 사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정 

cat << EOF >> $result  

[양호]: 홈 디렉터리 환경변수 파일 소유자가 root 또는 해당 계정으로 지정되어 있고 

홈 디렉터리 환경변수 파일에 root와 소유자만 쓰기 권한이 부여된 경우

[취약]: 홈 디렉터리 환경변수 파일 소유자가 root 또는 해당 계정으로 지정되지 않고 

홈 디렉터리 환경변수 파일에 root와 소유자 외에 쓰기 권한이 부여된 경우

EOF

BAR


files=( "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.bash_aliases" )

for file in "${files[@]}"; do
  if [ -w "$files" ]; then
  WARN "다른 사용자는 $file 에 대한 쓰기 권한을 가지고 있습니다."
else
  OK "다른 사용자는 $file 에 대한 쓰기 권한이 없습니다."
fi




cat $result

echo ; echo
 
