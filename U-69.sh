#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1   
 

BAR

CODE [U-69] NFS 설정파일 접근권한

cat << EOF >> $result

[양호]: NFS 접근제어 설정파일의 소유자가 root 이고, 권한이 644 이하인 경우

[취약]: NFS 접근제어 설정파일의 소유자가 root 가 아니거나, 권한이 644 초과인 경우

EOF

BAR

nfs_settings_file="/etc/exports"


# 파일이 있는지 확인하십시오
if [ ! -f $nfs_settings_file ]; then
  WARN "nfs_settings 파일이 존재하지 않습니다. 확인해주세요."
fi

# 파일 소유자 확인
if [[ $(stat -c '%U' $nfs_settings_file) = "root" ]]; then
  OK "nfs_settings의 소유자는 루트입니다. 이것은 허용됩니다."
else
  OK "nfs_settings의 소유자는 루트가 아닙니다. 이것은 허용되지 않습니다."
fi

# 파일에 대한 사용 권한 확인

if [[ $(stat -c '%a' $nfs_settings_file) -lt 644 ]]; then
  OK "nfs_settings에 대한 권한이 644보다 작습니다. 이것은 허용됩니다."
else
  WARN "nfs_settings에 대한 권한이 644보다 큽니다. 이것은 허용되지 않습니다."
fi



cat $result

echo ; echo 

