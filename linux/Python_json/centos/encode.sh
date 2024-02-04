#!/bin/bash

echo "결과가 $RESULTS_PATH에 저장되었습니다"
[ ${#errors[@]} -ne 0 ] && echo "오류가 $ERRORS_PATH에 기록되었습니다"
echo "HTML 결과 페이지가 $HTML_PATH에 생성되었습니다"

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

# ubunut Apache 설정 파일 경로
apache_config_file="/etc/apache2/conf-available/charset.conf"

# 주석 처리를 해제할 문자열
search_string="#AddDefaultCharset UTF-8"
replace_string="AddDefaultCharset UTF-8"

# 주석 처리된 부분을 해제하고 파일을 수정
sed -i "s/$search_string/$replace_string/" "$apache_config_file"

# centos Apache 설정 파일 경로
apache_config="/etc/httpd/conf/httpd.conf"

# 주석 처리를 해제할 문자열
search="#AddDefaultCharset UTF-8"
replace="AddDefaultCharset UTF-8"

# 주석 처리된 부분을 해제하고 파일을 수정
sed -i "s/$search/$replace/" "$apache_config"

# Apache 서비스 재시작
sudo systemctl restart apache2

sudo service apache2 restart

echo "Apache 설정이 업데이트되었고 서비스가 재시작되었습니다."