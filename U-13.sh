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

 

find / -user root -type f 2>/dev/null \( -perm -04000 -o -perm -02000 -o -perm -01000 \) -xdev -exec ls -l {} \; | awk '{print $1, $3, $4, $9}' > SUIDGIDSB.txt

CHECK_PERM=`find / -user root -type f 2>/dev/null \( -perm -04000 -o -perm -02000 -o -perm -01000 \) -xdev -exec ls -l {} \; | awk '{print $1, $3, $4, $9}' | wc -l`



if [ $CHECK_PERM = 0 ]; then
    OK "[양호] SETUID, SETGID, Sticky Bit가 설정된 파일이 없습니다."
else
    WARN "[취약] SETUID, SETGID, Sticky Bit가 설정된 파일이 $CHECK_PERM개 존재합니다."
    find / -user root -type f 2>/dev/null \( -perm -04000 -o -perm -02000 -o -perm -01000 \) -xdev -exec ls -l {} \; | awk '{print $1, $3, $4, $9}' >> SUIDGIDSB.txt
    INFO "SUIDGIDSB.txt파일을 참조하십시오."
fi




cat $result

echo ; echo

 
