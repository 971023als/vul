#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-38] Apache 불필요한 파일 제거 

cat << EOF >> $U38

[양호]: 매뉴얼 파일 및 디렉터리가 제거되어 있는 경우

[취약]: 매뉴얼 파일 및 디렉터리가 제거되지 않은 경우

EOF

BAR

 

#!/bin/bash

# Set the Apache2 Document Root directory to check
dir_path=$(grep -E "^[ \t]*DocumentRoot[ \t]+" /etc/apache2/sites-enabled/* | awk '{print $2}')

# Use find command to check all files and directories within the given path
# and use stat command to check the last accessed time
find $dir_path -mindepth 1 -type f -atime +30 -exec ls -alh {} + > /tmp/unnecessary_files.txt
find $dir_path -mindepth 1 -type d -atime +30 -exec ls -alh {} + >> /tmp/unnecessary_files.txt

if [ -s /tmp/unnecessary_files.txt ]; then
    WARN "Apache2에서 만든 불필요한 파일과 디렉터리가 제거되지 않았습니다. 다음 파일을 검토하십시오"
    INFO cat /tmp/unnecessary_files.txt
else
    OK "Apache2에서 만든 불필요한 파일 및 디렉터리가 탐지되지 않았습니다."
fi

cat $U38

echo ; echo