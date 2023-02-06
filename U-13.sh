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

# 지정한 파일에 대한 쓰기 권한 확인
check_write_permissions() {
  filename=$1
  if [ -w "$filename" ]; then
    WARN "$filename 는 다른 사용자가 쓸 수 있습니다."
  else
    OK "$filename 는 다른 사용자가 쓸 수 없습니다."
  fi
}

# 지정된 모든 파일에 대한 쓰기 권한 확인
check_write_permissions .profile
check_write_permissions .kshrc
check_write_permissions .cshrc
check_write_permissions .bashrc
check_write_permissions .bash_profile
check_write_permissions .login
check_write_permissions .exrc
check_write_permissions .netrc




cat $result

echo ; echo

 
