#!/bin/bash

# Apache 설치 여부 확인 및 설치
if ! command -v apache2 &> /dev/null; then
    echo "아파치 없음"
    sudo apt update && sudo apt install apache2 -y
else
    echo "아파치 존재"
fi

# 현재 사용자의 crontab 설정
CRON_JOB="/usr/bin/python3 /root/vul/linux/Python_json/ubuntu/vuln_check_script.py"
if crontab -l | grep -Fq "$CRON_JOB"; then
    echo "Cron job 존재함."
else
    (crontab -l 2>/dev/null; echo "0 0 * * * $CRON_JOB # Daily script execution") | crontab -
    echo "Cron job 존재하지 않음."
fi

#!/bin/bash

# 결과 및 오류 로그 저장 경로
NOW=$(date +'%Y-%m-%d_%H-%M-%S')
RESULTS_PATH="/var/www/html/results_${NOW}.json"
ERRORS_PATH="/var/www/html/errors_${NOW}.log"
HTML_PATH="/var/www/html/index.html"

# 결과 및 오류 초기화
results=()
errors=()

# U-01.py부터 U-72.py까지 실행
for i in $(seq -w 1 72); do
    script_name="U-${i}.py"
    start_time=$(date +%s.%N)
    output=$(python3 "$script_name" 2>&1)
    end_time=$(date +%s.%N)
    execution_time=$(echo "$end_time - $start_time" | bc)

    # 현재 시간을 포맷팅하여 출력에 추가
    current_datetime=$(date +"%Y-%m-%d %H:%M:%S.%N")
    result_json="{"
    result_json+="\"execution_time\": $execution_time,"
    result_json+="\"date\": \"$current_datetime\","
    result_json+="\"output\": $output"
    result_json+="}"

    echo "$result_json" >> "$RESULTS_PATH"

    if [[ $output == *ERROR* ]]; then
        errors+=("Error executing $script_name: $output")
    else
        results+=("\"script_$i\": {\"result\": \"$output\", \"execution_time\": $execution_time}")
    fi
done

# 결과를 JSON 파일로 저장
echo "{" > "$RESULTS_PATH"
echo "${results[*]}" | sed 's/} "/}, "/g' >> "$RESULTS_PATH"
echo "}" >> "$RESULTS_PATH"

# 오류가 있으면 로그 파일에 기록
if [ ${#errors[@]} -ne 0 ]; then
    printf "%s\n" "${errors[@]}" > "$ERRORS_PATH"
fi

# HTML 파일 생성
cat > "$HTML_PATH" <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>주요통신기반시설 취약점 진단</title>
    <meta charset="utf-8">
    <style>
        body { font-family: Arial, sans-serif; }
        pre {
            white-space: pre-wrap;
            word-wrap: break-word;
            text-align: center; /* 가운데 정렬을 위한 CSS 속성 추가 */
        }
        /* 기타 스타일링 및 CSS 규칙 추가 가능 */
    </style>
</head>
<body>
    <h1>주요통신기반시설 취약점 진단</h1>
    <div id="results">
        <pre>$(cat "$RESULTS_PATH")</pre>
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
