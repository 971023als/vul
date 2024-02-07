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
import os
from pathlib import Path

# 환경 변수에서 경로를 가져옴
json_path = os.getenv('RESULTS_PATH')
csv_path = os.getenv('CSV_PATH')
html_path = os.getenv('HTML_PATH')
csv_file_name = f"results_{os.getenv('NOW')}.csv" # CSV 파일의 웹 경로

# 환경 변수에서 경로를 가져옴
json_path = os.getenv('RESULTS_PATH')
csv_path = os.getenv('CSV_PATH')
html_path = os.getenv('HTML_PATH')
csv_file_name = f"results_{os.getenv('NOW')}.csv" # CSV 파일의 웹 경로

# JSON 데이터를 CSV로 변환하는 함수
def json_to_csv(json_path, csv_path):
    with open(json_path, 'r', encoding='utf-8') as json_file:
        json_data = json.load(json_file)
    with open(csv_path, 'w', newline='', encoding='utf-8') as csv_file:
        writer = csv.writer(csv_file)
        if json_data:
             writer.writerow(json_data[0].keys())  # column headers
            for item in json_data:
                writer.writerow(item.values())  # row values

# JSON 데이터를 HTML로 변환하는 함수 (다운로드 링크 포함)
def json_to_html(json_path, html_path, csv_file_name)
    with open(json_path, 'r', encoding='utf-8') as json_file:
        json_data = json.load(json_file)
    with open(html_path, 'w', encoding='utf-8') as html_file:
         html_file.write('<!DOCTYPE html>\n<html lang="en">\n<head>\n<meta charset="UTF-8">\n<title>Results</title>\n</head>\n<body>\n')
        html_file.write('<h1>Analysis Results</h1>\n')
        # CSV 다운로드 링크 추가
        html_file.write(f'<p><a href="{csv_file_name}">Download CSV</a></p>\n')
        html_file.write('<table border="1">\n<tr>\n')
        if json_data:
            for key in json_data[0].keys():
                html_file.write(f'<th>{key}</th>\n')
            html_file.write('</tr>\n')
            for item in json_data:
                html_file.write('<tr>\n')
                for value in item.values():
                    html_file.write(f'<td>{value}</td>\n')
                html_file.write('</tr>\n')
        html_file.write('</table>\n</body>\n</html>')

json_to_csv(json_path, csv_path)
json_to_html(json_path, html_path, csv_file_name)
EOF


echo "결과가 $CSV_PATH 및 $HTML_PATH에 저장되었습니다."

echo "작업이 완료되었습니다. 결과가 CSV 파일로 저장되었으며, HTML 페이지가 생성되었습니다."