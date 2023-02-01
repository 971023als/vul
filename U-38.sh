#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-38] Apache 불필요한 파일 제거 

cat << EOF >> $result

[양호]: 매뉴얼 파일 및 디렉터리가 제거되어 있는 경우

[취약]: 매뉴얼 파일 및 디렉터리가 제거되지 않은 경우

EOF

BAR

# 확인할 Apache2 Document Root 디렉토리 설정
dir_path=$(grep -E "^[ \t]*DocumentRoot[ \t]+" /etc/apache2/sites-enabled/* | awk '{print $2}')

# 지정된 경로 내의 모든 파일 및 디렉토리를 확인하려면 find 명령을 사용합니다
# stat 명령을 사용하여 마지막으로 액세스한 시간을 확인합니다
find $dir_path -mindepth 1 -type f -atime +30 -exec ls -alh {} + > /tmp/unnecessary_files.txt
find $dir_path -mindepth 1 -type d -atime +30 -exec ls -alh {} + >> /tmp/unnecessary_files.txt

if [ -s /tmp/unnecessary_files.txt ]; then
    WARN "Apache2에서 만든 불필요한 파일과 디렉터리가 제거되지 않았습니다. 다음 파일을 검토하십시오"
    INFO cat /tmp/unnecessary_files.txt
else
    OK "Apache2에서 만든 불필요한 파일 및 디렉터리가 탐지되지 않았습니다."
fi

cat $result

echo ; echo