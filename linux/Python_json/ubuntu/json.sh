#!/bin/bash

# 파일 경로 설정
NOW=$(date +'%Y-%m-%d_%H-%M-%S')
RESULTS_PATH="/var/www/html/results_${NOW}.json"  # 수정된 부분: 정확한 변수 정의
ERRORS_PATH="/var/www/html/errors_${NOW}.log"
CSV_PATH="/var/www/html/results_${NOW}.csv"
HTML_PATH="/var/www/html/index.html"
JSON_COMBINED_PATH="/var/www/html/combined_${NOW}.json"

# 초기 JSON 객체 시작
echo "{" > "$RESULTS_PATH"
errors=()

# U-01.py부터 U-72.py까지 실행하며 JSON 파일 생성
for i in $(seq -w 1 72); do
    script_name="U-${i}.py"
    start_time=$(date +%s.%N)
    output=$(python3 "$script_name" 2>&1)
    end_time=$(date +%s.%N)
    execution_time=$(echo "$end_time - $start_time" | bc)

    # output 값의 줄바꿈과 따옴표를 JSON 안전하게 이스케이프 처리
    output_escaped=$(echo "$output" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')

    # JSON 구조에 output 값을 포함시키기
    echo "\"U-${i}\": {\"output\": $output_escaped, \"execution_time\": \"$execution_time\"}," >> "$RESULTS_PATH"

    if [[ $output == *ERROR* ]]; then
        errors+=("$script_name: $output")
    fi
done

# 파일 마지막에 JSON 닫기
sed -i '$ s/,$/\n}/' "$RESULTS_PATH"

# 오류가 있으면 로그 파일에 기록
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
from pathlib import Path
import pandas as pd

# 파일 경로 설정
csv_path = '${CSV_PATH}'
html_path = '${HTML_PATH}'
json_combined_path = '${JSON_COMBINED_PATH}'
csv_web_path = '${CSV_WEB_PATH}'

def get_filelist(subfolder, file_extension):
    data_path = Path.cwd() / subfolder
    return list(data_path.glob('**/*.' + file_extension))

def combine_json_files(files):
    all_data = []
    for json_file in files:
        with open(json_file, 'r') as file:
            data = json.load(file)
            all_data.extend(data if isinstance(data, list) else [data])
    return all_data

def save_to_csv(data, csv_path):
    df = pd.DataFrame(data)
    df.to_csv(csv_path, index=False)

def generate_html(data, html_path, csv_web_path):
    html_content = '<!DOCTYPE html>\\n<html>\\n<head>\\n<title>결과 보고서</title>\\n<meta charset=\"utf-8\">\\n</head>\\n<body>\\n<h1>결과 보고서</h1>\\n<a href=\"' + csv_web_path + '\" download>CSV 파일 다운로드</a>\\n<table>\\n<tr>'
    for key in ['분류', '코드', '위험도', '진단 항목', '진단 결과', '현황', '대응방안']:
        html_content += f'<th>{key}</th>'
    html_content += '</tr>\\n'
    for item in data:
        html_content += '<tr>' + ''.join(f'<td>{item.get(key, "")}</td>' for key in ['분류', '코드', '위험도', '진단 항목', '진단 결과', '현황', '대응방안']) + '</tr>\\n'
    html_content += '</table>\\n</body>\\n</html>'
    with open(html_path, 'w') as html_file:
        html_file.write(html_content)

files = get_filelist('data', 'json')
all_data = combine_json_files(files)
save_to_csv(all_data, csv_path)
generate_html(all_data, html_path, csv_web_path)

with open(json_combined_path, 'w') as json_file:
    json.dump(all_data, json_file)
"

echo "작업이 완료되었습니다. 결과가 CSV 파일로 저장되었으며, HTML 페이지가 생성되었습니다."

# Apache 서비스 재시작
sudo systemctl restart apache2 || sudo systemctl restart httpd

# 오류 발생시 처리
if [ $? -ne 0 ]; then
    echo "Apache 서비스 재시작에 실패했습니다. 서비스 상태를 확인하세요."
else
    echo "Apache 서비스가 성공적으로 재시작되었습니다."
fi