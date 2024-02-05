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

# JSON 파일을 CSV로 변환
python3 -c "
import json
import csv

json_file_path = '$RESULTS_PATH'
csv_file_path = '$CSV_PATH'

with open(json_file_path, 'r') as json_file:
    data = json.load(json_file)

with open(csv_file_path, 'w', newline='') as csv_file:
    writer = csv.writer(csv_file)
    writer.writerow(['번호', '분류', '코드', '위험도', '진단항목', '진단결과', '현황', '대응방안'])
    for key, value in data.items():
        item = json.loads(value['output'])
        현황_formatted = ', '.join(item.get('현황', [])) if isinstance(item.get('현황'), list) else item.get('현황', '')
        writer.writerow([key, item.get('분류', ''), item.get('코드', ''), item.get('위험도', ''), item.get('진단 항목', ''), item.get('진단 결과', ''), 현황_formatted, item.get('대응방안', '')])
"

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

