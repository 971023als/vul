#!/bin/bash

. install.sh

. json.sh


# Apache 서비스 이름 확인
APACHE_SERVICE_NAME=$(systemctl list-units --type=service --state=active | grep -E 'apache2|httpd' | awk '{print $1}')

# Apache 서비스 재시작
if [ ! -z "$APACHE_SERVICE_NAME" ]; then
    echo "재시작할 Apache 서비스를 찾았습니다: $APACHE_SERVICE_NAME"
    sudo systemctl restart "$APACHE_SERVICE_NAME"
    if [ $? -eq 0 ]; then
        echo "$APACHE_SERVICE_NAME 서비스가 성공적으로 재시작되었습니다."
    else
        echo "$APACHE_SERVICE_NAME 서비스 재시작에 실패했습니다."
    fi
else
    echo "활성 상태인 Apache 또는 Httpd 서비스를 찾을 수 없습니다."
fi

. encode.sh
