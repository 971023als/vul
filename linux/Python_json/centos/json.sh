#!/bin/bash

# 파일 경로 및 기타 변수 설정

NOW=$(date +'%Y-%m-%d_%H-%M-%S')
RESULTS_PATH="/var/www/html/results_${NOW}.json"
ERRORS_PATH="/var/www/html/errors_${NOW}.log"
CSV_PATH="/var/www/html/results_${NOW}.csv"
HTML_PATH="/var/www/html/index.html"

echo "[" > "$RESULTS_PATH"
first_entry=true

# 오류 저장 배열 초기화
declare -a errors

# Run security check scripts
for i in $(seq -f "%02g" 1 72); do
    SCRIPT_PATH="U-$i.py"
    if [ -f "$SCRIPT_PATH" ]; then
     RESULT=$(python3 "$SCRIPT_PATH" 2>>"$ERRORS_PATH")
     if [ $? -eq 0 ]; then
      [ "$first_entry" != true ] && echo "," >> "$RESULTS_PATH"
            first_entry=false
             echo "$RESULT" >> "$RESULTS_PATH"
        else
            errors+=("Error running $SCRIPT_PATH")
            errors+=("$SCRIPT_PATH not found")
    fi
done

# 배열 닫기
echo "]" >> "$RESULTS_PATH"

# Log errors if any
if [ ${#errors[@]} -gt 0 ]; then
    printf "%s\n" "${errors[@]}" > "$ERRORS_PATH"
    echo "오류가 $ERRORS_PATH에 기록되었습니다."
else
    echo "오류 로그가 없습니다."
fi

# Generate CSV and HTML from JSON
python3 - <<EOF
import json
import csv
from pathlib import Path

# 파일 경로 설정
json_path = Path('data.json') # JSON 파일 경로
csv_path = Path('data.csv') # CSV 파일 경로
html_path = Path('data.html') # HTML 파일 경로

# JSON을 CSV로 변환
def json_to_csv():
    with json_path.open('r', encoding='utf-8') as json_file, \
         csv_path.open('w', newline='', encoding='utf-8') as csv_file:
        data = json.load(json_file)
        if data:
            headers = data[0].keys()
            writer = csv.DictWriter(csv_file, fieldnames=headers)
            writer.writeheader()
            for item in data:
                writer.writerow(item)

# JSON을 HTML로 변환
def json_to_html():
    with json_path.open('r', encoding='utf-8') as json_file, \
         html_path.open('w', encoding='utf-8') as html_file:
        data = json.load(json_file)
        html_file.write('<!DOCTYPE html><html><head><title>Results</title></head><body><h1>Analysis Results</h1><a href="{}">Download CSV</a><table border="1">'.format(csv_path.name))
        if data:
            headers = data[0].keys()
            html_file.write('<tr>' + ''.join(f'<th>{h}</th>' for h in headers) + '</tr>')
            for item in data:
                row = ''.join(f'<td>{item[h]}</td>' for h in headers)
                html_file.write(f'<tr>{row}</tr>')
        html_file.write('</table></body></html>')

# 변환 실행
json_to_csv()
json_to_html()
EOF

echo "결과가 $CSV_PATH 및 $HTML_PATH에 저장되었습니다."

echo "작업이 완료되었습니다. 결과가 CSV 파일로 저장되었으며, HTML 페이지가 생성되었습니다."

# Apache 서비스 재시작 로직 개선
APACHE_SERVICE_NAME=$(systemctl list-units --type=service --state=active | grep -E 'apache2|httpd' | awk '{print $1}')
if [ ! -z "$APACHE_SERVICE_NAME" ]; then
    sudo systemctl restart "$APACHE_SERVICE_NAME" && echo "$APACHE_SERVICE_NAME 서비스가 성공적으로 재시작되었습니다." || echo "$APACHE_SERVICE_NAME 서비스 재시작에 실패했습니다."
else
    echo "Apache/Httpd 서비스를 찾을 수 없습니다."
fi
