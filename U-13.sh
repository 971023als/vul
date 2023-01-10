#!/bin/bash

 

. function.sh

 



 

BAR

CODE [U-13] SUID,SGID,Sticky bit 설정파일 점검 

cat << EOF >> $RESULT

[양호]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우

[취약]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있는 경우

EOF

BAR

 

CHECK1=$(find / -user root -type f \( -perm 4000 -o -perm -2000 \) >> /root/linuxs/U-13.txt 2>&1)

for i in /sbin/dump /sbin/restore /sbin/unix_chkpwd /usr/bin/at /usr/bin/lpq /usr/bin/lpq-lpd /usr/bin/lpr /usr/bin/lpr-lpd /usr/bin/lprm /usr/bin/lprm-lqp /usr/bin/newgrp /usr/sbin/lpc /usr/sbin/lpc-lpd /usr/sbin/traceroute
do
	cat /root/linuxs/U-13.txt | grep $i >> /root/linuxs/U-13_1.txt 
done

CHECK3=$(cat /root/linuxs/U-13_1.txt | wc -l )

if [ $CHECK3 = 0 ] ; then
	OK "주요 실행파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우"
else
	VULN "주요 실행파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있는 경우"
fi




echo >>$RESULT

echo >>$RESULT

 
