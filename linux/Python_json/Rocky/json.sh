#!/bin/bash

# 파일 경로 및 기타 변수 설정
NOW=$(date +'%Y-%m-%d_%H-%M-%S')
RESULTS_PATH="/var/www/html/results_${NOW}.json"
ERRORS_PATH="/var/www/html/errors_${NOW}.log"
CSV_PATH="/var/www/html/results_${NOW}.csv"
HTML_PATH="/var/www/html/index.html"

# 결과 파일 초기화 및 시작 배열 마크업 작성
echo -n "[" > "$RESULTS_PATH"

# 오류 저장 배열 초기화
declare -a errors

# U-01.py부터 U-72.py까지 실행
for i in $(seq -f "%02g" 1 72)
do
    SCRIPT_PATH="U-$i.py"
    if [ -f "$SCRIPT_PATH" ]; then
        # Python 스크립트 실행하고 변수에 결과 저장
        RESULT=$(python3 "$SCRIPT_PATH" 2>>"$ERRORS_PATH")
        if [ $? -eq 0 ]; then
            # 첫 번째 항목이 아니라면, 배열 항목 구분을 위한 쉼표 추가
            if [ -s "$RESULTS_PATH" ]; then
                echo -n "," >> "$RESULTS_PATH"
            fi
            # 결과 출력
            echo -n "$RESULT" >> "$RESULTS_PATH"
        else
            errors+=("Error running $SCRIPT_PATH")
        fi
    else
        errors+=("$SCRIPT_PATH not found")
    fi
done

# 배열 닫기
echo "]" >> "$RESULTS_PATH"

# 오류 로그 기록
if [ ${#errors[@]} -gt 0 ]; then
    printf "%s\n" "${errors[@]}" > "$ERRORS_PATH"
    echo "오류가 $ERRORS_PATH에 기록되었습니다."
else
    echo "오류 로그가 없습니다."
fi

echo "결과가 $RESULTS_PATH에 저장되었습니다."

# JSON 파일 처리 및 HTML, CSV 파일 생성을 위한 Python 코드 실행
python3 - <<EOF
import json
import csv
import os
from pathlib import Path

json_path = "$RESULTS_PATH"
csv_path = "$CSV_PATH"
html_path = "$HTML_PATH"
csv_file_name = "results_${NOW}.csv" # CSV 파일의 웹 경로

# JSON 데이터를 CSV로 변환하는 함수
def json_to_csv(json_path, csv_path):
      try:
        with open(json_path, 'r') as json_file:
            json_data = json.load(json_file)
    except json.JSONDecodeError as e:
        print(f"JSON 파일 처리 중 오류 발생: {e}")
        return
    with open(csv_path, 'w', newline='', encoding='utf-8') as csv_file:
        writer = csv.writer(csv_file)
        if json_data:
            writer.writerow(json_data[0].keys())
            for item in json_data:
                writer.writerow(item.values())

# JSON 데이터를 HTML로 변환하는 함수 (다운로드 링크 포함)
def json_to_html(json_path, html_path, csv_file_name):
    with open(json_path, 'r') as json_file:
        json_data = json.load(json_file)
    with open(html_path, 'w', encoding='utf-8') as html_file:
        html_file.write('<!DOCTYPE html>\n<html>\n<head>\n<title>Results</title>\n</head>\n<body>\n')
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

