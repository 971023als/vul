#!/bin/bash

# 운영체제 확인 및 패키지 관리자 설정
OS=$(uname -s)
if [ "$OS" = "Linux" ]; then
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        if [[ "$ID" =~ (debian|ubuntu) || "$ID_LIKE" =~ (debian|ubuntu) ]]; then
            PKG_MANAGER="apt"
        elif [[ "$ID" =~ (centos|rhel) || "$ID_LIKE" =~ (fedora) ]]; then
            if [[ "$VERSION_ID" -ge 8 ]]; then
                PKG_MANAGER="dnf"
            else
                PKG_MANAGER="yum"
            fi
        else
            echo "지원되지 않는 리눅스 배포판입니다."
        fi
    else
        echo "/etc/os-release 파일을 찾을 수 없습니다. 리눅스 배포판을 확인할 수 없습니다."
    fi
else
    echo "이 스크립트는 리눅스에서만 지원됩니다."
fi

# 파이썬 설치 여부 확인 및 설치
if ! command -v python3 &> /dev/null; then
    echo "파이썬이 설치되어 있지 않습니다. 파이썬을 설치합니다."
    sudo $PKG_MANAGER update && sudo $PKG_MANAGER install python3 -y
else
    echo "파이썬이 이미 설치되어 있습니다."
fi

# 아파치 설치 여부 확인 및 설치
if ! command -v apache2 &> /dev/null && ! command -v httpd &> /dev/null; then
    echo "아파치가 설치되어 있지 않습니다. 아파치를 설치합니다."
    if [[ "$PKG_MANAGER" == "apt" ]]; then
        sudo apt update && sudo apt install apache2 -y
    else # CentOS, RHEL, Fedora
        sudo $PKG_MANAGER install httpd -y
    fi
else
    echo "아파치가 이미 설치되어 있습니다."
fi

# 현재 사용자의 crontab 설정
CRON_JOB="/usr/bin/python3 /root/vul/linux/Python_json/ubuntu/vul.sh"
if crontab -l | grep -Fq "$CRON_JOB"; then
    echo "Cron job이 이미 존재합니다."
else
    (crontab -l 2>/dev/null; echo "0 0 * * * $CRON_JOB # 매일 스크립트 실행") | crontab -
    echo "Cron job을 추가했습니다."
fi