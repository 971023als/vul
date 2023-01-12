#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1   
 

BAR

CODE [U-69] NFS 설정파일 접근권한

cat << EOF >> $result

[양호]: NFS 접근제어 설정파일의 소유자가 root 이고, 권한이 644 이하인 경우

[취약]: NFS 접근제어 설정파일의 소유자가 root 가 아니거나, 권한이 644 이하가 아닌 경우

EOF

BAR

nfs_settings_file="/path/to/nfs_settings"

# Check if the file exists
if [ ! -f $nfs_settings_file ]; then
  WARN "nfs_settings 파일이 존재하지 않습니다. 확인해주세요.."
fi

# Check owner of the file
if [ `stat -c '%U' $nfs_settings_file` == "root" ]; then
  WARN "nfs_settings의 소유자는 루트입니다. 이것은 허용되지 않습니다."
fi

# Check permission on the file
if [ `stat -c '%a' $nfs_settings_file` -lt 644 ]; then
  WARN "nfs_settings에 대한 권한이 644보다 작습니다. 이것은 허용되지 않습니다."
fi

OK "https_https 파일이 있고 소유자와 권한이 예상대로입니다."



cat $result

echo ; echo 

