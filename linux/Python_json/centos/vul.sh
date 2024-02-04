#!/bin/bash

. install.sh

. json.sh

# HTML 파일 생성
cat > "$HTML_PATH" <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>주요통신기반시설 취약점 진단</title>
    <meta charset="utf-8">
    <style>
        body { font-family: Arial, sans-serif; text-align: center; } /* 전체 페이지 가운데 정렬 */
        h1 { text-align: center; } /* 제목 가운데 정렬 */
        table { margin: 0 auto; } /* 표 중앙 정렬 */
        pre {
            white-space: pre-wrap;
            word-wrap: break-word;
        }
    </style>
    <script src="json.js"></script> <!-- 스크립트 파일을 포함합니다 -->
</head>
<body>
    <h1>주요통신기반시설 취약점 진단</h1>
    <div id="results">
        <table border="1">
            <tr>
                <th>순서</th>
                <th>분류</th>
                <th>위험도</th>
                <th>진단항목</th>
                <th>진단결과</th>
                <th>현황</th>
                <th>대응방안</th>
                <th>생성시간</th>
            </tr>
        </table>
    </div>
    $(if [ -s "$ERRORS_PATH" ]; then echo "<h2>Error Log</h2><pre>$(cat "$ERRORS_PATH")</pre>"; fi)
</body>
</html>
EOF


echo "Results saved to $RESULTS_PATH"
[ ${#errors[@]} -ne 0 ] && echo "Errors logged to $ERRORS_PATH"
echo "HTML results page created at $HTML_PATH"

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
