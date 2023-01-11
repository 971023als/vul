#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-37] Apache 상위 디렉터리 접근 금지 

cat << EOF >> $RESULT

[양호]: 상위 디렉터리에 이동제한을 설정한 경우

[취약]: 상위 디렉터리에 이동제한을 설정하지 않은 경우

EOF

BAR


# Set the Apache2 Document Root directory to check
dir_path=$(grep -E "^[ \t]*DocumentRoot[ \t]+" /etc/apache2/sites-enabled/* | awk '{print $2}')

# Use find command to check all files and directories within the given path 
# and use stat command to check the move restriction bit
result=$(find $dir_path -mindepth 1 -type d -exec stat -c '%a %n' {} + | awk '{ if ($1 % 1000 / 100 != 7 ) print $2}')

if [ -n "$result" ]; then
    WARN "Apache2 Document Root에서 이동 제한이 설정되지 않은 디렉터리가 있습니다: 정보"
    INFO $result
else
    OK "모든 디렉터리에는 Apache2 Document Root에 설정된 이동 제한이 있습니다."
fi



cat $RESULT

echo ; echo

 

 

