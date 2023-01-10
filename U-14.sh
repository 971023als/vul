#!/bin/bash

 

. function.sh

 

BAR

CODE [U-14] 사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정 

cat << EOF >> $RESULT

[양호]: 홈 디렉터리 환경변수 파일 소유자가 root 또는 해당 계정으로 지정되어 있고 

홈 디렉터리 환경변수 파일에 root와 소유자만 쓰기 권한이 부여된 경우

[취약]: 홈 디렉터리 환경변수 파일 소유자가 root 또는 해당 계정으로 지정되지 않고 

홈 디렉터리 환경변수 파일에 root와 소유자 외에 쓰기 권한이 부여된 경우

EOF

BAR

 

 

TMP1=$(mktemp)

TMP2=$(mktemp)

TRUEFALSE=1

 

cat /etc/passwd | awk -F: '$3 >= 500 && $3 < 60000 {print $1}' > $TMP1

 

for i in `cat $TMP1`

do

ls -al /home/$i \ | grep '(.profile|.kshrc|.cshrc|.bashrc|.bash_profile|.login|.exrc)' \ | awk '{print $3}' > $TMP2

for j in `cat $TMP2`

do

case $j in

$i) : ;;

root) : ;;

*) 

WARN 환경변수의 소유자가 다른 계정으로 지정되어 있습니다. 

INFO /home/$i의 환경 파일을 확인하십시오

TRUEFALSE=0 ;;

esac

done

done

 

if [ $TRUEFALSE -eq 1 ] ; then

OK 환경 변수의 소유자 설정이 양호합니다. 

fi

 

echo >>$RESULT

echo >>$RESULT

 
