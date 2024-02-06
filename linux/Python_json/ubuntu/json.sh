##!/bin/bash

# 파일 경로 설정
NOW=$(date +'%Y-%m-%d_%H-%M-%S')
RESULTS_PATH="/var/www/html/results_${NOW}.json"
ERRORS_PATH="/var/www/html/errors_${NOW}.log"
CSV_PATH="/var/www/html/results_${NOW}.csv"  # CSV 파일 경로 추가
HTML_PATH="/var/www/html/index.html"

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
    echo "\"$i\": {\"output\": $output_escaped, \"execution_time\": \"$execution_time\"}," >> "$RESULTS_PATH"

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
fi

echo "결과가 $RESULTS_PATH에 저장되었습니다."

# Python 코드 실행: 하위 폴더의 모든 JSON 파일을 하나의 JSON 객체로 합치고 CSV로 저장
python3 -c "
import json
from pathlib import Path
import pandas as pd

def get_filelist(subfolder, file_extension):
    data_path = Path.cwd() / subfolder
    return list(data_path.glob('**/*.' + file_extension))

# 'data' 폴더 내 모든 JSON 파일 목록을 가져옴
files = get_filelist('data', 'json')

# 모든 JSON 데이터를 저장할 리스트
all_data = []

# 파일들을 순회하며 데이터 리스트에 추가
for json_file in files:
    with open(json_file, 'r') as file:
        data = json.load(file)
        all_data.extend(data)  # 각 파일은 데이터의 리스트를 포함

# JSON 데이터를 파일로 저장 (선택적)
with open('$JSON_PATH', 'w') as file:
    json.dump(all_data, file)

# 모든 데이터를 pandas DataFrame으로 변환
df = pd.DataFrame(all_data)

# 결과를 CSV 파일로 저장
df.to_csv('$CSV_PATH', index=False)
"

echo "합쳐진 JSON 파일이 $JSON_PATH 에 저장되었습니다."
echo "CSV 파일이 $CSV_PATH 에 저장되었습니다."

# Python 코드 실행: JSON 파일을 읽고 HTML로 변환
python3 -c "
import json

HTML_PATH = '$HTML_PATH'
RESULTS_PATH = '$RESULTS_PATH'

# HTML 파일 시작
html_content = '<!DOCTYPE html>\\n'
html_content += '<html>\\n<head>\\n'
html_content += '<title>주요 통신 기반 시설 진단 결과</title>\\n'
html_content += '<meta charset=\"utf-8\">\\n'
html_content += '<style>\\n'
html_content += 'body { font-family: Arial, sans-serif; text-align: center; }\\n'
html_content += 'table { margin: 0 auto; border-collapse: collapse; }\\n'
html_content += 'th, td { border: 1px solid black; padding: 8px; }\\n'
html_content += 'th { background-color: #f2f2f2; }\\n'
html_content += '</style>\\n'
html_content += '</head>\\n<body>\\n'
html_content += '<h1>주요 통신 기반 시설 진단 결과</h1>\\n'
html_content += '<table>\\n'
html_content += '<tr><th>번호</th><th>분류</th><th>코드</th><th>위험도</th><th>진단항목</th><th>진단결과</th><th>현황</th><th>대응방안</th></tr>\\n'

with open(RESULTS_PATH, 'r') as json_file:
    data = json.load(json_file)
    for key, value in data.items():
        item = json.loads(value['output'])
        현황_formatted = '<br>'.join(item.get('현황', [])) if isinstance(item.get('현황'), list) else item.get('현황', '')
        html_content += f'<tr><td>{key}</td><td>{item.get("분류", "")}</td><td>{item.get("코드", "")}</td><td>{item.get("위험도", "")}</td><td>{item.get("진단 항목", "")}</td><td>{item.get("진단 결과", "")}</td><td>{현황_formatted}</td><td>{item.get("대응방안", "")}</td></tr>\\n'

html_content += '</table>\\n</body>\\n</html>'

with open(HTML_PATH, 'w') as html_file:
    html_file.write(html_content)
"

echo "HTML 결과 페이지가 $HTML_PATH에 생성되었습니다."


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

