#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-22] cron 파일 소유자 및 권한 설정

cat << EOF >> $RESULT

[양호]: cron 접근제어 파일 소유자가 root이고, 권한이 640 이하인 경우

[취약]: cron 접근제어 파일 소유자가 root가 아니거나, 권한이 640 이하가 아닌 경우

EOF

BAR

 

 

# cat filepem.list

# /etc/cron.allow root 640 rw-r-----

# /etc/cron.deny root 640 rw-r-----

 

 

PEM_FILE=filepem.list #상대경로

TMP2=/tmp/tmp2

> $TMP2

TMP3=/tmp/tmp3

> $TMP3

 

cat $PEM_FILE | while read FILE1 OWNER1 PERM1 PERM2

do

# echo "$FILE1 $OWNER1 $PERM1 $PERM2"

FILENAME=$(basename $FILE1)

if [ -f $FILE1 ] ; then

FILE_ATTR=$(ls -l $FILE1 | awk '{print $1, $3, $4}')

find /etc -name $FILENAME -type f -user $OWNER1 -perm -$PERM1 \

-ls | grep -v $PERM2 > $TMP2

if [ -s $TMP2 ] ; then

echo "[ WARN ] $FILE1 ($FILE_ATTR)" >> $TMP3

else

echo "[ OK ] $FILE1 ($FILE_ATTR)" >> $TMP3

fi

else

echo "[ OK ] $FILE1 존재하지 않습니다." >> $TMP3

fi

done

 

cat << EOF >> $TMP1

=======================================================================

/etc/cron.allow 파일이 존재하면서, root 사용자 소유이고, 권한이 640 이하인지 점검한다.

/etc/cron.deny 파일이 존재하면서, root 사용자 소유이고, 권한이 640 이하인지 점검한다.

ex) find /etc/ -name /etc/cron.deny -user root -perm -640 -ls | grep -v 'rw-r-----'

=======================================================================

EOF

 

cat $TMP3 >> $TMP1

 

if grep -w -q 'WARN' $TMP3 ; then

WARN 'cron 접근제어 파일 소유자가 root가 아니거나, 권한이 640 이하가 아닌 경우'

else

OK 'cron 접근제어 파일 소유자가 root이고, 권한이 640 이하인 경우 입니다'

fi

INFO "자세한 정보는 $TMP1 파일을 참고해 주세요."

 

 

# 오류나는 부분에 ; read 추가해 bash -x 디버깅 모드로 돌려 검사

cat $RESULT

echo ; echo
