#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

>$TMP1

 

 

BAR

CODE [U-09] /etc/hosts 파일 소유자 및 권한 설정.

cat << EOF >> $RESULT

[양호]: /etc/hosts 파일의 소유자가 root이고, 권한이 600인 경우

[취약]: /etc/hosts 파일의 소유자가 root가 아니거나, 권한이 600이 아닌 경우

EOF

BAR

 

 

FILE=hperm.list

# cat herm.list

#/etc/hosts root 600 rw-------

 

 

TMP2=/tmp/tmp2

>$TMP2

TMP3=/tmp/tmp3

>$TMP3

 

 

cat $FILE | while read FILE1 OWNER1 PERM1 PERM2

do

# echo $FILE1 $OWNER1 $PERM1 $PERM2

FILENAME=$(basename $FILE1)

if [ -f $FILE1 ] ; then

FILE_CHECK=$(ls -l $FILE1 | awk '{print $1, $3}')

find /etc -name $FILENAME -type f -user $OWNER1 -perm -$PERM1 \

-ls | grep -v $PERM2 > $TMP2 

if [ -s $TMP2 ] ; then

echo "[ CHECK ] $FILE1 ($FILE_CHECK)" >>$TMP3

else

echo "[ WARN ] $FILE1 ($FILE_CHECK)" >>$TMP3

fi

else

INFO $FILE1 파일이 존재하지 않습니다. >> $TMP3

fi

done

 

cat << EOF >> $TMP1

=========================================================================

(1) /etc/hosts 파일의 소유자가 root이고, 권한이 600인 경우인지 확인 하세요!

(2) /etc/hosts 파일의 소유자가 root가 아니거나, 권한이 600이 아닌 경우인지 확인 하세요!

 

ex) find /etc/ -name hosts -user root -perm -600 -ls | grep -v 'rw-------'

=========================================================================

 

EOF

 

 

cat $TMP3 >> $TMP1

 

 

 

if grep -w -q WARN $TMP3 ; then

WARN "/etc/hosts 파일의 소유자가 root가 아니거나, 권한이 600이 아닌 경우"

else

OK "etc/hosts 파일의 소유자가 root이고, 권한이 600인 경우"

fi

INFO "자세한 내용은 $TMP1 파일을 확인 하세요."

 

cat $RESULT

echo ; echo
