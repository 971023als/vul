#!/bin/bash

# 운영체제 확인 및 패키지 관리자 설정
OS=$(uname -s)
PKG_MANAGER=""

if [ "$OS" = "Linux" ]; then
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        if [[ "$ID" =~ (debian|ubuntu) ]]; then
            PKG_MANAGER="apt-get"
        elif [[ "$ID" =~ (centos|rhel) ]]; then
            PKG_MANAGER="yum"
            if [[ "$VERSION_ID" -ge 8 ]]; then
                PKG_MANAGER="dnf"
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

# python3-venv 설치 여부 확인
if ! command -v python3-venv &> /dev/null; then
    echo "python3-venv이 설치되어 있지 않습니다. 설치를 시작합니다."
    
    # 패키지 매니저 확인
    if [[ "$PKG_MANAGER" == "apt-get" ]]; then
      echo "Debian/Ubuntu 시스템을 위한 python3-venv 패키지를 설치합니다."
      sudo apt-get update
      sudo apt-get install python3-venv -y
    else
        echo "이 스크립트는 Debian/Ubuntu 시스템과 apt-get 패키지 매니저를 사용하는 시스템에만 적용됩니다."
    fi
else
    echo "python3-venv이 이미 설치되어 있습니다."
fi


# 아파치 및 mod_wsgi 설치 여부 확인 및 설치
if [[ "$PKG_MANAGER" == "apt-get" ]]; then
    if ! apache2 -v &> /dev/null; then
        echo "아파치가 설치되어 있지 않습니다. 아파치를 설치합니다."
        sudo apt-get update && sudo apt-get install apache2 -y
        sudo apt-get install libapache2-mod-wsgi-py3 -y  # Python 3용
    else
        echo "아파치가 이미 설치되어 있습니다."
    fi
elif [[ "$PKG_MANAGER" == "dnf" ]] || [[ "$PKG_MANAGER" == "yum" ]]; then
    if ! httpd -v &> /dev/null; then
        echo "아파치가 설치되어 있지 않습니다. 아파치를 설치합니다."
        sudo $PKG_MANAGER install httpd -y
        sudo $PKG_MANAGER install mod_wsgi -y  # Python 3용, 필요에 따라 패키지 이름 확인
    else
        echo "아파치가 이미 설치되어 있습니다."
    fi
fi

# 현재 사용자의 crontab 설정
CRON_JOB="/usr/bin/python3 /root/vul/linux/Python_json/ubuntu/vul.sh"
if crontab -l | grep -Fq "$CRON_JOB"; then
    echo "Cron job이 이미 존재합니다."
else
    (crontab -l 2>/dev/null; echo "0 0 * * * $CRON_JOB # 매일 스크립트 실행") | crontab -
    echo "Cron job을 추가했습니다."
fi
