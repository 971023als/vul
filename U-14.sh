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


# 사용 권한을 확인할 파일
file="/etc/environment"

# 파일이 있는지 확인하십시오
if [ -f "$file" ]; then
  # 파일의 사용 권한 가져오기
  perms=$(stat -c %a "$file")
  # 파일에 다른 사용자에 대한 쓰기 권한이 있는지 확인합니다
  if [ $((perms & 2)) -ne 0 ]; then
    OK "$file 에는 다른 사용자에 대한 쓰기 권한이 있습니다."
  else
    WARN "$file 에는 다른 사용자에 대한 쓰기 권한이 없습니다."
  fi
else
  INFO "$file 이 없습니다."
fi



cat $result

echo ; echo
 
