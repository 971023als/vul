#!/bin/bash

 

. function.sh

 

BAR

CODE [U-33]  DNS 보안 버전 패치 '확인 필요'

cat << EOF >> $RESULT

[양호]: DNS 서비스를 사용하지 않거나 주기적으로 패치를 관리하고 있는 경우

[취약]: DNS 서비스를 사용하며 주기적으로 패치를 관리하고 있지 않는 경우


EOF

BAR

 

ps -ef | grep named

 

if [ $? -eq 0 ] ; then

WARN  DNS 서비스가 활성화 되어 있습니다.

else

OK DNS 서비스가 비활성화 되어 있습니다. 

fi

 

echo >>$RESULT

echo >>$RESULT