#!/bin/bash

# 파일 경로 설정
NOW=$(date +'%Y-%m-%d_%H-%M-%S')
CSV_PATH="/var/www/html/results_${NOW}.csv"  # CSV 파일 경로
HTML_PATH="/var/www/html/index.html"
JSON_COMBINED_PATH="/var/www/html/combined_${NOW}.json"  # 합쳐진 JSON 파일 경로
# CSV 파일의 웹 경로 정의
CSV_WEB_PATH = f"results_${NOW}.csv"

# 메인 로직에서 generate_html 함수 호출
generate_html(all_data, '$HTML_PATH', CSV_WEB_PATH)

# Python 코드 실행: JSON 파일 처리 및 HTML 파일 생성
python3 -c "
import json
from pathlib import Path
import pandas as pd

def get_filelist(subfolder, file_extension):
    '''하위 폴더 내의 모든 파일을 불러오는 함수'''
    data_path = Path.cwd() / subfolder
    return list(data_path.glob('**/*.' + file_extension))

def combine_json_files(files):
    '''JSON 파일들을 하나의 리스트로 합치는 함수'''
    all_data = []
    for json_file in files:
        with open(json_file, 'r') as file:
            data = json.load(file)
            all_data.extend(data)
    return all_data

def save_to_csv(data, csv_path):
    '''데이터를 CSV 파일로 저장하는 함수'''
    df = pd.DataFrame(data)
    df.to_csv(csv_path, index=False)

def generate_html(data, html_path, csv_filename):
    '''데이터를 기반으로 HTML 파일을 생성하는 함수, 다운로드 링크 포함'''
    html_content = '<!DOCTYPE html>\\n<html>\\n<head>\\n<title>결과 보고서</title>\\n<meta charset=\"utf-8\">\\n</head>\\n<body>\\n<h1>결과 보고서</h1>\\n'
    # CSV 다운로드 링크 추가
    html_content += f'<a href="{csv_filename}" download>CSV 파일 다운로드</a>\\n'
    html_content += '<table>\\n<tr>'
    if data:
        # 테이블 헤더 생성
        html_content += ''.join(f'<th>{key}</th>' for key in data[0].keys())
    html_content += '</tr>\\n'
    for item in data:
        html_content += '<tr>' + ''.join(f'<td>{item.get(key, "")}</td>' for key in item.keys()) + '</tr>\\n'
    html_content += '</table>\\n</body>\\n</html>'
    with open(html_path, 'w') as html_file:
        html_file.write(html_content)


# 메인 로직
files = get_filelist('data', '.json')
all_data = combine_json_files(files)
save_to_csv(all_data, '$CSV_PATH')
generate_html(all_data, '$HTML_PATH')

# 선택적: 합쳐진 JSON 데이터를 파일로 저장
with open('$JSON_COMBINED_PATH', 'w') as json_file:
    json.dump(all_data, json_file)
"

echo "작업이 완료되었습니다. 결과가 CSV 파일로 저장되었으며, HTML 페이지가 생성되었습니다."



# Ubuntu/Debian 시스템용
sudo systemctl restart apache2

# CentOS/RHEL 시스템용 (필요한 경우)
sudo systemctl restart httpd


# 오류 발생시 처리
if [ $? -ne 0 ]; then
    echo "Apache 서비스 재시작에 실패했습니다. 서비스 상태를 확인하세요."
else
    echo "Apache 서비스가 성공적으로 재시작되었습니다."
fi

