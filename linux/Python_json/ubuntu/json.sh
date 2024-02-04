#!/bin/bash

# 결과 및 오류 로그 저장 경로
RESULTS_PATH="/var/www/html/results.json"
ERRORS_PATH="/var/www/html/errors.log"
HTML_PATH="/var/www/html/index.html"

# 초기 JSON 객체 시작
echo "{" > "$RESULTS_PATH"
errors=()

# U-01.py부터 U-72.py까지 실행
for i in $(seq -w 1 72); do
    script_name="U-${i}.py"
    start_time=$(date +%s.%N)
    output=$(python3 "$script_name" 2>&1)
    end_time=$(date +%s.%N)
    execution_time=$(echo "$end_time - $start_time" | bc)

    # jq를 사용하여 JSON 문자열 생성
    jq -n --arg i "$i" --arg output "$output" --arg execution_time "$execution_time" \
       '{($i): {"output": $output, "execution_time": $execution_time}}' >> "$RESULTS_PATH"

    if [[ $output == *ERROR* ]]; then
        errors+=("$script_name: $output")
    fi

    # 마지막 항목이 아니라면 쉼표 추가
    if [[ $i -ne 72 ]]; then
        echo "," >> "$RESULTS_PATH"
    fi
done

# 파일 마지막에 JSON 닫기
echo "}" >> "$RESULTS_PATH"

# 오류가 있으면 로그 파일에 기록
if [ ${#errors[@]} -ne 0 ]; then
    printf "%s\n" "${errors[@]}" > "$ERRORS_PATH"
fi
