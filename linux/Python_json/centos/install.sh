#!/bin/bash

# 파이썬 설치 여부 확인 및 설치
if ! command -v python3 &> /dev/null; then
    echo "파이썬이 설치되어 있지 않습니다. 파이썬을 설치합니다."
    sudo apt update && sudo apt install python3 -y
else
    echo "파이썬이 이미 설치되어 있습니다."
fi

# 아파치 설치 여부 확인 및 설치
if ! command -v apache2 &> /dev/null; then
    echo "아파치가 설치되어 있지 않습니다. 아파치를 설치합니다."
    sudo apt update && sudo apt install apache2 -y
else
    echo "아파치가 이미 설치되어 있습니다."
fi

# 현재 사용자의 crontab 설정
CRON_JOB="/usr/bin/python3 /root/vul/linux/Python_json/ubuntu/vul.sh"
if crontab -l | grep -Fq "$CRON_JOB"; then
    echo "Cron job이 이미 존재합니다."
else
    (crontab -l 2>/dev/null; echo "0 0 * * * $CRON_JOB # 매일 스크립트 실행") | crontab -
    echo "Cron job이 존재하지 않습니다."
fi