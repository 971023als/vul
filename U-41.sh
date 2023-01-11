#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-41] Apache 웹 서비스 영역의 분리 

cat << EOF >> $RESULT

[양호]: DocumentRoot를 별도의 디렉터리로 지정한 경우

[취약]: DocumentRoot를 기본 디렉터리로 지정한 경우

EOF

BAR

 
# Set the Apache2 configuration file path
config_file="/etc/apache2/apache2.conf"

# Use grep to check if the LimitRequestBody, LimitXMLRequestBody and LimitUploadSize options are enabled in the configuration file
upload_result=$(grep -E "^[ \t]*LimitRequestBody" $config_file)
download_result=$(grep -E "^[ \t]*LimitXMLRequestBody" $config_file)
upload_size_result=$(grep -E "^[ \t]*LimitUploadSize" $config_file)

if [ -n "$upload_result" ] || [ -n "$download_result" ] || [ -n "$upload_size_result" ] ; then
    echo "Apache2에서 파일 업로드 및 다운로드가 제한됩니다"
else
    echo "Apache2에서 파일 업로드 및 다운로드가 제한되지 않습니다."
fi

cat $RESULT

echo ; echo
