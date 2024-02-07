#!/bin/bash

# 파일 경로 및 기타 변수 설정
NOW=$(date +'%Y-%m-%d_%H-%M-%S')
RESULTS_PATH="/var/www/html/results_${NOW}.json"
ERRORS_PATH="/var/www/html/errors_${NOW}.log"
CSV_PATH="/var/www/html/results_${NOW}.csv"
HTML_PATH="/var/www/html/index.html"

declare -a errors

execute_script() {
    local script_name=$1
    local start_time=$(date +%s.%N)
    local output=$(python3 "$script_name" 2>&1)
    local end_time=$(date +%s.%N)
    local execution_time=$(echo "$end_time - $start_time" | bc)
    local output_escaped=$(echo "$output" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
    echo "\"$script_name\": {\"output\": $output_escaped, \"execution_time\": \"$execution_time\"}," >> "$RESULTS_PATH"
    if [[ $output == *ERROR* ]]; then
        errors+=("$script_name: $output")
    fi
}

# JSON 파일 생성 시작
echo "{" > "$RESULTS_PATH"

# U-01.py부터 U-72.py까지 실행
for i in $(seq -w 1 72); do
    execute_script "U-${i}.py"
done

# 파일 마지막에 JSON 닫기
sed -i '$ s/,$/\n}/' "$RESULTS_PATH"

# 오류 로그 기록
if [ ${#errors[@]} -gt 0 ]; then
    printf "%s\n" "${errors[@]}" > "$ERRORS_PATH"
    echo "오류가 $ERRORS_PATH에 기록되었습니다."
else
    echo "오류 로그가 없습니다."
fi

echo "결과가 $RESULTS_PATH에 저장되었습니다."

# Python 코드 실행: JSON 파일 처리 및 HTML 파일 생성
python3 -c "
import json
import pandas as pd

# 파일 경로 설정
csv_path = '$CSV_PATH'
html_path = '$HTML_PATH'
results_path = '$RESULTS_PATH'

def save_to_csv(data, csv_path):
    df = pd.DataFrame(data)
    df.to_csv(csv_path, index=False)

def generate_html(data, html_path, csv_path):
    html_content = '<!DOCTYPE html>\\n<html>\\n<head>\\n<title>결과 보고서</title>\\n<meta charset=\"utf-8\">\\n</head>\\n<body>\\n<h1>결과 보고서</h1>\\n<a href=\"' + csv_path.replace('/var/www/html', '') + '\" download>CSV 파일 다운로드</a>\\n<table>\\n<tr>'
    for key in ['분류', '코드', '위험도', '진단 항목', '진단 결과', '현황', '대응방안']:
        html_content += f'<th>{key}</th>'
    html_content += '</tr>\\n'
    for item in data:
        html_content += '<tr>' + ''.join(f'<td>{item.get(key, \"\")}</td>' for key in ['분류', '코드', '위험도', '진단 항목', '진단 결과', '현황', '대응방안']) + '</tr>\\n'
    html_content += '</table>\\n</body>\\n</html>'
    with open(html_path, 'w') as html_file:
        html_file.write(html_content)
"

echo "작업이 완료되었습니다. 결과가 CSV 파일로 저장되었으며, HTML 페이지가 생성되었습니다."

# Apache 서비스 재시작
if systemctl is-active --quiet apache2; then
    sudo systemctl restart apache2 && echo "Apache 서비스가 성공적으로 재시작되었습니다." || echo "Apache 서비스 재시작에 실패했습니다."
elif systemctl is-active --quiet httpd; then
    sudo systemctl restart httpd && echo "Httpd 서비스가 성공적으로 재시작되었습니다." || echo "Httpd 서비스 재시작에 실패했습니다."
else
    echo "Apache/Httpd 서비스를 찾을 수 없습니다."
fi
