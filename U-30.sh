#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1
 
 

BAR

CODE [U-30] Sendmail 버전 점검

cat << EOF >> $result

[양호]: Sendmail 버전이 최신버전인 경우 

[취약]: Sendmail 버전이 최신버전이 아닌 경우

EOF

BAR


SI=`yum list installed | grep sendmail | awk '{print $1}'`

if [ $SI ]
	then
		SV=`echo \$Z | /usr/lib/sendmail -bt -d0 | sed -n '1p' | awk '{print $2}'`
		OK "    [OOOO] 설치된 sendmail의 버전은 $SV 입니다" 
		OK "    ==> [권장] 최신 버전의 설치 및 업그레이드를 위해 sendmail 데몬의 중지가 필요하기 때문에 적절한 시간대에 수행해야 함" 
	else
		WARN "    [XXXX] sendmail이 설치되어 있지 않습니다 " 
fi





cat $result

echo ; echo
 
