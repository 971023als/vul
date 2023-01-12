#!/bin/bash

 

. function.sh


TMP1=`SCRIPTNAME`.log

> $TMP1  

 

BAR

CODE [U-36] Apache 웹 프로세스 권한 제한 

cat << EOF >> $result

[양호]: Apache 데몬이 root 권한으로 구동되지 않는 경우

[취약]: Apache 데몬이 root 권한으로 구동되는 경우

EOF

BAR

# Check if httpd process is running
if pgrep -x "httpd" > /dev/null
then
    INFO "아파치 데몬(httpd)이 실행 중입니다.."
else
    INFO "아파치 데몬(httpd)이 실행되고 있지 않습니다.."
fi

# Get the user and group of the httpd process
httpd_user=$(ps -o user= -p $(pgrep -x "httpd"))
httpd_group=$(ps -o group= -p $(pgrep -x "httpd"))

# Check if the httpd process is running as root
if [[ $httpd_user == "root" || $httpd_group == "root" ]]
then
    WARN "Apache 데몬(httpd)이 루트 권한으로 실행되고 있습니다"
else
    OK "Apache 데몬(httpd)이 루트 권한으로 실행이 안되고 있습니다"
fi



cat $result

echo ; echo

 
