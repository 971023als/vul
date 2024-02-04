#!/bin/bash

# 결과 및 오류 로그 저장 경로 설정
NOW=$(date +'%Y-%m-%d_%H-%M-%S')
RESULTS_PATH="/var/www/html/results_${NOW}.json"
ERRORS_PATH="/var/www/html/errors_${NOW}.log"
HTML_PATH="/var/www/html/index.php"

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

    # output 값이 비어있지 않은 경우에만 처리
    if [ -z "$output" ]; then
        output="\"\"" # 비어 있는 경우 빈 문자열 할당
    else
        # 줄바꿈, 따옴표 등을 JSON 문자열에 맞게 이스케이프 처리
        output=$(echo "$output" | jq -aRs .)
    fi

    # JSON 구조에 output 값을 포함시키기
    echo "\"$i\": {\"output\": $output, \"execution_time\": \"$execution_time\"}," >> "$RESULTS_PATH"

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
