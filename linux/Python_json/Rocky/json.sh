#!/bin/bash

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
    with open(json_path, 'r') as json_file:
        json_data = json.load(json_file)
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
        html_file.write('<!DOCTYPE html>\n<html>\n<head>\n<meta charset="UTF-8">\n<title>취약점 진단 보고서</title>\n')
        # CSS 추가
        html_file.write('<style>\n')
        html_file.write('table, th, td { border: 1px solid #bcbcbc; border-collapse: collapse; }\n')
        html_file.write('th, td { padding: 10px; }\n')
        html_file.write('table { width: 100%; margin-bottom: 20px; }\n')
        html_file.write('.good { background-color: #90ee90; }\n')
        html_file.write('.vulnerable { background-color: #ff726f; }\n')
        html_file.write('.na { background-color: #d3d3d3; }\n')
        html_file.write('.high { background-color: #ff726f; }\n')
        html_file.write('.medium { background-color: #ffdf70; }\n')
        html_file.write('.low { background-color: #90ee90; }\n')
        html_file.write('</style>\n')
        html_file.write('</head>\n<body>\n')
        html_file.write('<h1>취약점 진단 보고서</h1>\n')
        html_file.write(f'<p><a href="{csv_file_name}">Download CSV</a></p>\n')
        html_file.write('<table>\n<tr>\n')
        # 테이블 헤더 생성
        if json_data:
            for key in json_data[0].keys():
                html_file.write(f'<th>{key}</th>\n')
            html_file.write('</tr>\n')
            # 테이블 데이터 로우 생성
            for item in json_data:
                html_file.write('<tr>\n')
                for key, value in item.items():
                    cell_class = ''
                    if key == "진단 결과":
                        cell_class = 'good' if value == "양호" else 'vulnerable' if value == "취약" else 'na'
                    elif key == "위험도":
                        cell_class = 'high' if value == "상" else 'medium' if value == "중" else 'low'
                    html_file.write(f'<td class="{cell_class}">{value}</td>\n')
                html_file.write('</tr>\n')
        html_file.write('</table>\n</body>\n</html>')
json_to_csv(json_path, csv_path)
json_to_html(json_path, html_path, csv_file_name)
EOF