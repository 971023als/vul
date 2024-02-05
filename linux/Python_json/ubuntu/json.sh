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

# HTML 파일을 생성하기 위한 Python 스크립트 시작
python3 -c "
import json

# HTML 파일 경로
HTML_PATH = '$HTML_PATH'
# 결과 JSON 파일 경로
RESULTS_PATH = '$RESULTS_PATH'

# HTML 파일 생성
with open(HTML_PATH, 'w') as html_file:
    # HTML 파일 기본 구조 작성
    html_file.write('<!DOCTYPE html>\\n<html>\\n<head>\\n<title>주요 통신 기반 시설 진단 결과</title>\\n<meta charset=\"utf-8\">\\n<style>\\nbody { font-family: Arial, sans-serif; text-align: center; }\\ntable { margin: 0 auto; border-collapse: collapse; }\\nth, td { border: 1px solid black; padding: 8px; }\\nth { background-color: #f2f2f2; }\\n</style>\\n</head>\\n<body>\\n<h1>주요 통신 기반 시설 진단 결과</h1>\\n<table>\\n<tr><th>번호</th><th>분류</th><th>코드</th><th>위험도</th><th>진단항목</th><th>진단결과</th><th>현황</th><th>대응방안</th></tr>')

    # JSON 파일 읽기
    with open(RESULTS_PATH) as json_file:
        data = json.load(json_file)
        
        for key, value in data.items():
            # JSON 데이터 파싱
            item = json.loads(value['output'].replace('\\n', '<br>'))  # JSON 문자열 내 줄바꿈을 HTML 줄바꿈으로 변환
            현황 = '<br>'.join(item.get('현황', [])) if item.get('현황') else ''

            # HTML 테이블 행 추가
            html_file.write(f'<tr><td>{key}</td><td>{item.get("분류", "")}</td><td>{item.get("코드", "")}</td><td>{item.get("위험도", "")}</td><td>{item.get("진단 항목", "")}</td><td>{item.get("진단 결과", "")}</td><td>{현황}</td><td>{item.get("대응방안", "")}</td></tr>\\n')

    # HTML 파일 종료 태그
    html_file.write('</table>\\n</body>\\n</html>')"

echo "HTML 결과 페이지가 ${HTML_PATH}에 생성되었습니다."


# Apache 웹 서버 재시작 (Ubuntu/Debian 시스템 기준)
sudo systemctl restart apache2



# 오류 발생시 처리
if [ $? -ne 0 ]; then
    echo "Apache 서비스 재시작에 실패했습니다. 서비스 상태를 확인하세요."
else
    echo "Apache 서비스가 성공적으로 재시작되었습니다."
fi

