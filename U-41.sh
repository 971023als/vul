#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-41] Apache 웹 서비스 영역의 분리 

cat << EOF >> $result

[양호]: DocumentRoot를 별도의 디렉터리로 지정한 경우

[취약]: DocumentRoot를 기본 디렉터리로 지정한 경우

EOF

BAR



# Set the Apache2 configuration file path
config_file="/etc/apache2/sites-enabled/*"

# Use grep to check if the DocumentRoot directive is defined in the configuration file
Result=$(grep -E "^[ \t]*DocumentRoot[ \t]+" $config_file)

if [ -n "$Result" ]; then
    OK "Apache2 DocumentRoot는 구성 파일에 정의되어 있습니다."
else
    WARN "Apache2 DocumentRoot가 구성 파일에 정의되어 있지 않습니다."
fi

cat $result

echo ; echo
