#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

>$TMP1

 

 

BAR 

CODE [U-08] /etc/shadow 파일 소유자 및 권한 설정

cat << EOF >> $RESULT

[양호]: /etc/shadow 파일의 소유자가 root이고, 권한이 400인 경우

[취약]: /etc/shadow 파일의 소유자가 root가 아니거나, 권한이 400이 아닌 경우

EOF

BAR

 

 

TMP2=/tmp/tmp2

>$TMP2

TMP3=/tmp/tmp3

>$TMP3

 

 

PERMFILE=sperm.list

 

 

cat $PERMFILE | while read FILE1 OWNER1 PERM1 PERM2

do

# echo $FILE1 $OWNER1 $PERM1 $PERM2

FILENAME=$(basename $FILE1)

if [ -f $FILE1 ] ; then

FILE_ATTR=$(ls -l $FILE1 | awk '{print $1, $3}') 

find /etc -name $FILENAME -type f -user $OWNER1 -perm -$PERM1 \

-ls | grep -v $PERM2 > $TMP2 

if [ -s $TMP2 ] ; then

echo "[ WARN ] $FILE1 ($FILE_ATTR)" >> $TMP3

else

echo "[ OK ] $FILE1 ($FILE_ATTR)" >> $TMP3

fi

else

"[ INFO ] $FILE1 가 존재하지 않습니다." >> $TMP3

fi

done

 

 

cat<< EOF >>$TMP1

=======================================================================

/etc/shadow 파일의 소유자가 root이고, 권한이 400인 경우인지 점검한다.

/etc/shadow 파일의 소유자가 root가 아니거나, 권한이 400이 아닌 경우를 점검한다.

ex) find /etc/ -name /etc/shadow -user root -perm -640 -ls | grep -v 'r--------'

=======================================================================

 

EOF

 

 

cat $TMP3 >>$TMP1

 

 

if grep -w -q 'WARN' $TMP3 ; then

WARN '파일의 소유자가 root가 아니거나, 권한이 400이 아닌 경우 입니다.'

else

OK '파일의 소유자가 root이고 권한이 400인 경우 입니다.'

fi

INFO "자세한 정보는 $TMP1 파일을 참고해 주세요."

 

 

cat $RESULT

echo ; echo
