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

executables=("/bin/ping" "/usr/bin/passwd" "/usr/bin/sudo")

for exec in "${executables[@]}"; do
  # SUID 확인
  suid=$(stat -c '%u' "$exec")
  if [ "$suid" -ne 0 ]; then
    OK "SUID가 $exec 에 설정되었습니다."
  else
    WARN "$exec 에 SUID가 설정되지 않았습니다."
  fi

  # SGID 확인
  sgid=$(stat -c '%g' "$exec")
  if [ "$sgid" -ne 0 ]; then
    OK "SGID가 $exec 에 설정되었습니다."
  else
    WARN "$exec 에 SGID가 설정되지 않았습니다."
  fi
done






cat $result

echo ; echo

 
