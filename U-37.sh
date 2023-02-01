#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-37] Apache 상위 디렉터리 접근 금지 

cat << EOF >> $result

[양호]: 상위 디렉터리에 이동제한을 설정한 경우

[취약]: 상위 디렉터리에 이동제한을 설정하지 않은 경우

EOF

BAR


# 확인할 Apache2 Document Root 디렉토리 설정
dir_path=$(grep -E "^[ \t]*DocumentRoot[ \t]+" /etc/apache2/sites-enabled/* | awk '{print $2}')

# 지정된 경로 내의 모든 파일 및 디렉토리를 확인하려면 find 명령을 사용합니다
# stat 명령을 사용하여 이동 제한 비트를 확인합니다
Result=$(find $dir_path -mindepth 1 -type d -exec stat -c '%a %n' {} + | awk '{ if ($1 % 1000 / 100 != 7 ) print $2}')

if [ -n "$Result" ]; then
    WARN "Apache2 Document Root에서 이동 제한이 설정되지 않은 디렉터리가 있습니다"
    INFO $Result
else
    OK "모든 디렉터리에는 Apache2 Document Root에 설정된 이동 제한이 있습니다."
fi



cat $result

echo ; echo

 

 

