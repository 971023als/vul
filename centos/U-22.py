#!/bin/bash

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

BAR

CODE [U-22] cron 파일 소유자 및 권한 설정

cat << EOF >> $result

[양호]: cron 접근제어 파일 소유자가 root이고, 권한이 640 이하인 경우

[취약]: cron 접근제어 파일 소유자가 root가 아니거나, 권한이 640 이하가 아닌 경우

EOF

BAR

# 파일 정의
files=(/etc/crontab /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.allow /etc/cron.deny /var/spool/cron* /var/spool/cron/crontabs/)

for file in "${files[@]}"; do
  if [ -e "$file" ]; then
    owner=$(stat -c %U "$file")
    if [ "$owner" != "root" ]; then
      WARN "$file 은 root가 아닌 $owner가 소유합니다"
    else
      OK "$file 은 root가 소유합니다"
    fi
  else
    INFO "$file이 존재하지 않습니다"
  fi
done

for file in "${files[@]}"; do
  if [ -e "$file" ]; then
    perms=$(stat -c %a "$file")
    if [ "$perms" -lt 640 ]; then
      WARN "$file 에 $perms 권한이 640보다 큽니다"
    else
      OK "$file 에 $perms 권한이 640보다 작습니다"
    fi
  else
    INFO "$file이 존재하지 않습니다"
  fi
done

cat $result

echo ; echo

if nonexistent_device_files:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-22",
            "위험도": "상",
            "진단 항목": "cron 파일 소유자 및 권한설정",
            "진단 결과": "취약",
            "현황": " r 계열 서비스 활성화 되어 있는 경우",
            "대응방안": " /usr/bin/crontab 파일과 Crontab 관련 파일의 권한을 640(-rw-r-----)으로 설정"
        })
    else:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-22",
            "위험도": "상",
            "진단 항목": "cron 파일 소유자 및 권한설정",
            "진단 결과": "양호",
            "현황": " r 계열 서비스 비활성화 되어 있는 경우",
            "대응방안": " /usr/bin/crontab 파일과 Crontab 관련 파일의 권한을 640(-rw-r-----)으로 설정"
        })

return results