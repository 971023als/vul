#!/bin/bash

[ ${#errors[@]} -ne 0 ] && echo "오류가 $ERRORS_PATH에 기록되었습니다"

# 원하는 기본 인코딩 코드 설정
encoding_code="utf-8"

# httpd.conf 파일 수정
sudo sed -i "s/AddDefaultCharset .*/AddDefaultCharset $encoding_code/" /etc/apache2/apache2.conf

# 웹 페이지가 있는 디렉토리 경로 설정
web_directory="/var/www/html"

# 각 HTML 파일에 META 태그 추가
for html_file in $(find $web_directory -name "*.html"); do
    echo "<meta charset=\"$encoding_code\">" >> "$html_file"
done

# 우분투 Apache 설정 파일 경로
apache_config_file="/etc/apache2/conf-available/charset.conf"

# 주석 처리를 해제할 문자열
search_string="#AddDefaultCharset UTF-8"
replace_string="AddDefaultCharset UTF-8"

# 주석 처리된 부분을 해제하고 파일을 수정
sed -i "s/$search_string/$replace_string/" "$apache_config_file"

# CentOS Apache 설정 파일 경로
apache_config="/etc/httpd/conf/httpd.conf"

# 주석 처리를 해제할 문자열
search="#AddDefaultCharset UTF-8"
replace="AddDefaultCharset UTF-8"

# 주석 처리된 부분을 해제하고 파일을 수정
sed -i "s/$search/$replace/" "$apache_config"

# 복사할 파일 목록
FILES=("index.html")

# /var/www/html로 파일 복사
for file in "${FILES[@]}"; do
  if [ -f "$file" ]; then
    echo "$file을(를) /var/www/html로 복사합니다."
    cp "$file" "/var/www/html/"
  else
    echo "경고: $file이(가) 존재하지 않아 복사되지 않습니다."
  fi
done


# Apache 서비스 재시작 로직 개선
APACHE_SERVICE_NAME=$(systemctl list-units --type=service --state=active | grep -E 'apache2|httpd' | awk '{print $1}')
if [ ! -z "$APACHE_SERVICE_NAME" ]; then
    sudo systemctl restart "$APACHE_SERVICE_NAME" && echo "$APACHE_SERVICE_NAME 서비스가 성공적으로 재시작되었습니다." || echo "$APACHE_SERVICE_NAME 서비스 재시작에 실패했습니다."
