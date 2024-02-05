#!/bin/bash

# 파일 경로 설정
NOW=$(date +'%Y-%m-%d_%H-%M-%S')
JSON_PATH="/path/to/your_file.json"
CSV_PATH="/var/www/html/results_${NOW}.csv"
HTML_PATH="/var/www/html/index.html"

# JSON을 CSV로 변환하는 Python 코드 직접 실행
python3 -c "
import pandas as pd
import sys

json_file_path = sys.argv[1]
csv_file_path = sys.argv[2]

df = pd.read_json(json_file_path)
df.to_csv(csv_file_path, index=False)
" "$JSON_PATH" "$CSV_PATH"

# CSV를 HTML로 변환하는 Python 코드 직접 실행
python3 -c "
import pandas as pd
import sys

csv_file_path = sys.argv[1]
html_file_path = sys.argv[2]

df = pd.read_csv(csv_file_path)
html_string = df.to_html()

with open(html_file_path, 'w') as html_file:
    html_file.write(html_string)
" "$CSV_PATH" "$HTML_PATH"

echo "HTML 결과 페이지가 $HTML_PATH에 생성되었습니다."


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

    # output 값이 비어있지 않은 경우에만 처리
    if [ -z "$output" ]; then
        output_escaped="\"\""
    fi

    # JSON 구조에 output 값을 포함시키기
    echo "\"$i\": {\"output\": \"$output_escaped\", \"execution_time\": \"$execution_time\"}," >> "$RESULTS_PATH"

    if [[ $output == *ERROR* ]]; then
        errors+=("$script_name: $output")
    fi
done

# 파일 마지막에 JSON 닫기
# sed를 사용하여 마지막 콤마를 제거하고 닫는 중괄호 추가
sed -i '$ s/,$/\n}/' "$RESULTS_PATH"

# 오류가 있으면 로그 파일에 기록
if [ ${#errors[@]} -ne 0 ]; then
    printf "%s\n" "${errors[@]}" > "$ERRORS_PATH"
fi

echo "결과가 $RESULTS_PATH에 저장되었습니다"
[ ${#errors[@]} -ne 0 ] && echo "오류가 $ERRORS_PATH에 기록되었습니다"
echo "HTML 결과 페이지가 $HTML_PATH에 생성되었습니다"