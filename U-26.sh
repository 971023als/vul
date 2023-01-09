#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-26] automountd 제거 '확인 필요'

cat << EOF >> $RESULT

[양호]: automountd 서비스가 비활성화 되어있는 경우

[취약]: automountd 서비스가 활성화 되어있는 경우

EOF

BAR

 

ps -ef | grep automount |  grep autofs

 

if [ $? -eq 0 ] ; then

WARN  automountd 서비스가 활성화 되어 있습니다.

else

OK automountd 서비스가 비활성화 되어 있습니다. 

fi

 

echo >>$RESULT

echo >>$RESULT