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
        html_file.write('<!DOCTYPE html>\n<html>\n<head>\n<title>취약점 진단 보고서</title>\n')
        # CSS 추가
        html_file.write('<style>\n')
        html_file.write('.wide-column { width: 300px; }\n')  # 특정 열의 가로 크기 조절
        html_file.write('.good { background-color: #90ee90; }\n')  # 양호 - 초록색
        html_file.write('.vulnerable { background-color: #ff726f; }\n')  # 취약 - 빨간색
        html_file.write('.na { background-color: #d3d3d3; }\n')  # 오류 - 회색
        html_file.write('.high { background-color: #ff726f; }\n')  # 위험도 상 - 빨간색
        html_file.write('.medium { background-color: #ffdf70; }\n')  # 위험도 중 - 노란색
        html_file.write('.low { background-color: #90ee90; }\n')  # 위험도 하 - 초록색
        html_file.write('</style>\n')
        html_file.write('</head>\n<body>\n')
        html_file.write('<h1>취약점 진단</h1>\n')
        html_file.write(f'<p><a href="{csv_file_name}">Download CSV</a></p>\n')
        html_file.write('<table border="1">\n<tr>\n')
        if json_data:
            for key in json_data[0].keys():
                html_file.write(f'<th>{key}</th>\n')
            html_file.write('</tr>\n')
            for item in json_data:
                html_file.write('<tr>\n')
                for key, value in item.items():
                    cell_class = ""
                    if key == "진단 결과":
                        if value == "양호":
                            cell_class = "good"
                        elif value == "취약":
                            cell_class = "vulnerable"
                        elif value == "오류":
                            cell_class = "na"
                    elif key == "위험도":
                        if value == "상":
                            cell_class = "high"
                        elif value == "중":
                            cell_class = "medium"
                        elif value == "하":
                            cell_class = "low"
                    if cell_class:
                        html_file.write(f'<td class="{cell_class}">{value}</td>\n')
                    else:
                        html_file.write(f'<td>{value}</td>\n')
                html_file.write('</tr>\n')
        html_file.write('</table>\n</body>\n</html>')
json_to_csv(json_path, csv_path)
json_to_html(json_path, html_path, csv_file_name)
EOF