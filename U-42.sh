#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-42] 최신 보안패치 및 벤더 권고사항 적용

cat << EOF >> $RESULT

[양호]: 패치 적용 정책을 수립하여 주기적으로 패치를 관리하고 있는 경우

[취약]: 패치 적용 정책을 수립하지 않고 주기적으로 패치관리를 하지 않는 경우

EOF

BAR

 

INFO 1.다음 사이트에서 해당 버전을 찾는다.

INFO http://www.redhat.com/security/updates/

INFO http://www.redhat.com/security/updates/eol/ -Red Hat Linux 9 이하 버전

INFO 2.발표된 Update 중 현재 사용 중인 보안 관련 Update 찾아 해당 Update Download

INFO 3.Update 설치

 

echo >>$RESULT

echo >>$RESULT

 
