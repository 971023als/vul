#!/bin/bash

# 파일 경로 설정
NOW=$(date +'%Y-%m-%d_%H-%M-%S')
RESULTS_PATH="/var/www/html/results_${NOW}.json"
ERRORS_PATH="/var/www/html/errors_${NOW}.log"
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

    # output 값의 줄바꿈과 따옴표를 이스케이프 처리
    output_escaped=$(echo "$output" | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}' ORS='')

    # JSON 구조에 output 값을 포함시키기
    echo "\"$i\": {\"output\": \"$output_escaped\", \"execution_time\": \"$execution_time\"}," >> "$RESULTS_PATH"

    if [[ $output == *ERROR* ]]; then
        errors+=("$script_name: $output")
    fi
done

# 파일 마지막에 JSON 닫기
sed -i '$ s/,$/\n}/' "$RESULTS_PATH"

# 오류가 있으면 로그 파일에 기록
if [ ${#errors[@]} -ne 0 ]; then
    printf "%s\n" "${errors[@]}" > "$ERRORS_PATH"
fi

# Execute Python code to convert JSON to HTML
python3 -c "
import json

# Specify the HTML and RESULTS path directly
HTML_PATH = '$HTML_PATH'
RESULTS_PATH = '$RESULTS_PATH'

# Open the HTML file for writing
with open(HTML_PATH, 'w') as html_file:
    # Write the HTML structure
    html_file.write('<!DOCTYPE html>\\n<html>\\n<head>\\n<title>주요 통신 기반 시설 진단 결과</title>\\n<meta charset=\"utf-8\">\\n<style>\\nbody { font-family: Arial, sans-serif; text-align: center; }\\ntable { margin: 0 auto; border-collapse: collapse; }\\nth, td { border: 1px solid black; padding: 8px; }\\nth { background-color: #f2f2f2; }\\n</style>\\n</head>\\n<body>\\n<h1>주요 통신 기반 시설 진단 결과</h1>\\n<table>\\n<tr><th>번호</th><th>분류</th><th>코드</th><th>위험도</th><th>진단항목</th><th>진단결과</th><th>현황</th><th>대응방안</th></tr>')
    
    # Read and process the JSON file
    with open(RESULTS_PATH) as json_file:
        data = json.load(json_file)
        for key, value in data.items():
            # Parse the JSON output from each script's result
            try:
                item = json.loads(value['output'])
                status = '<br>'.join(item.get('현황', [])) if '현황' in item else ''
                # Write each row of the table
                html_file.write(f'<tr><td>{key}</td><td>{item.get("분류", "")}</td><td>{item.get("코드", "")}</td><td>{item.get("위험도", "")}</td><td>{item.get("진단 항목", "")}</td><td>{item.get("진단 결과", "")}</td><td>{status}</td><td>{item.get("대응방안", "")}</td></tr>\\n')
            except json.JSONDecodeError:
                # Handle possible JSON decoding errors
                html_file.write(f'<tr><td colspan=\"8\">Error processing item {key}</td></tr>\\n')

    # Close the HTML structure
    html_file.write('</table>\\n</body>\\n</html>')"

echo "HTML conversion completed and saved to ${HTML_PATH}."



# Apache 웹 서버 재시작 (Ubuntu/Debian 시스템 기준)
sudo systemctl restart apache2



# 오류 발생시 처리
if [ $? -ne 0 ]; then
    echo "Apache 서비스 재시작에 실패했습니다. 서비스 상태를 확인하세요."
else
    echo "Apache 서비스가 성공적으로 재시작되었습니다."
fi

