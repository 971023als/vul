#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-63] ftpusers 파일 소유자 및 권한 설정

cat << EOF >> $TMP1

[양호]: ftpusers 파일의 소유자가 root이고, 권한이 640 이하인 경우

[취약]: ftpusers 파일의 소유자가 root아니거나, 권한이 640 이하가 아닌 경우

EOF

BAR

 

# Set the path of the ftpusers file
ftpusers_file="/etc/ftpusers"

# Check if the ftpusers file exists
if [ ! -f $ftpusers_file ]; then
    echo "ftpusers 파일이 존재하지 않습니다."
else
    # Use the stat command to get the owner and permission of the ftpusers file
    owner=$(stat -c %U $ftpusers_file)
    permission=$(stat -c %a $ftpusers_file)

    # Check if the owner is not root
    if [ "$owner" != "root" ]; then
        echo "ftp users 파일의 소유자가 루트가 아닙니다."
    fi

    # Check if the permission is not set to 640 or less
    if [ $permission -gt 640 ]; then
        echo "ftp 사용자 파일의 권한이 640 이하로 설정되지 않았습니다."
    fi
fi



cat $TMP1

echo ; echo 

 
