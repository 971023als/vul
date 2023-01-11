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

# Check if apache2 process is running
if pgrep -x "apache2" > /dev/null
then
    echo "Apache 데몬(apache2)이 실행 중입니다."
else
    echo "Apache 데몬(apache2)이 실행되고 있지 않습니다."
fi

# Get the parent process id of the apache2 process
parent_pid=$(ps -o ppid= -p $(pgrep -x "apache2"))

# Check if the parent process of apache2 is owned by root
parent_user=$(ps -o user= -p $parent_pid)

if [[ $parent_user == "root" ]]
then
    echo "Apache 데몬(apache2)이 루트에 의해 실행되었습니다."
else
    echo "Apache 데몬(apache2)이 루트에 의해 실행되지 않았습니다."
fi




cat $result

echo ; echo

 
