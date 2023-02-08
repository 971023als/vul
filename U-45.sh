#!/bin/bash

. function.sh


TMP1=`SCRIPTNAME`.log

> $TMP1

BAR

CODE [U-45] root 계정 su 제한

cat << EOF >> $result

[양호]: su 명령어를 특정 그룹에 속한 사용자만 사용하도록 제한되어 있는 경우

[취약]: su 명령어를 모든 사용자가 사용하도록 설정되어 있는 경우

EOF

BAR

# 휠 그룹이 /etc/group 파일에 정의되어 있는지 확인하십시오
grep -q '^wheel:' /etc/group
if [ $? -eq 0 ]; then
  # 휠 그룹이 정의됨
  
  # SUID 비트가 su 명령에 대해 설정되었는지 확인합니다
  ls -l $(which su) | grep -q '^-rwsr-xr-x'
  if [ $? -eq 0 ]; then
    # SUID 비트가 설정되었습니다
    
    # 휠 그룹이 su 실행 권한이 있는 유일한 그룹인지 점검하십시오
    ls -l $(which su) | grep -q '^.*wheel.*$'
    if [ $? -eq 0 ]; then
      # 휠 그룹에만 su 실행 권한이 있습니다
      OK "SU 명령은 휠 그룹의 사용자로 제한됩니다."
    else
      # 허가는 휠 그룹으로만 제한되지 않습니다
      WARN "SU 명령은 휠 그룹의 사용자로 제한되지 않습니다."
    fi
  else
    # SUID 비트가 SU 명령에 대해 설정
    WARN "SUID 비트가 SU 명령에 대해 설정되지 않았습니다."
  fi
else
  # 휠 그룹이 /etc/group 파일에 정의
  WARN "휠 그룹이 /etc/group 파일에 정의되어 있지 않습니다."
fi
 

cat $result

echo ; echo
