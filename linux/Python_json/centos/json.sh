#!/bin/bash

# 결과 및 오류 로그 저장 경로
RESULTS_PATH="/var/www/html/results.json"
ERRORS_PATH="/var/www/html/errors.log"
HTML_PATH="/var/www/html/index.html"

# 결과 및 오류 초기화
echo "{" > "$RESULTS_PATH"
errors=()

# U-01.py부터 U-72.py까지 실행
for i in $(seq -w 1 72); do
    script_name="U-${i}.py"
    start_time=$(date +%s.%N)
    output=$(python3 "$script_name" 2>&1)
    end_time=$(date +%s.%N)

    # JSON 형식의 결과 문자열 생성
    echo "\"$i\": {\"output\": \"$output\"}," >> "$RESULTS_PATH"

    if [[ $output == *ERROR* ]]; then
        errors+=("$script_name: $output")
    fi
done

# 파일 마지막에 JSON 닫기
sed -i '$ s/,$/}/' "$RESULTS_PATH" # 마지막 쉼표를 닫는 중괄호로 변경

# 오류가 있으면 로그 파일에 기록
if [ ${#errors[@]} -ne 0 ]; then
    printf "%s\n" "${errors[@]}" > "$ERRORS_PATH"
fi
