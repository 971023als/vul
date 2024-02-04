#!/bin/bash

# 결과 및 오류 로그 저장 경로
NOW=$(date +'%Y-%m-%d_%H-%M-%S')
RESULTS_PATH="/var/www/html/results_${NOW}.json"
ERRORS_PATH="/var/www/html/errors_${NOW}.log"
HTML_PATH="/var/www/html/index.html"

# 결과 및 오류 초기화
results=()
errors=()

# U-01.py부터 U-72.py까지 실행
for i in $(seq -w 1 72); do
    script_name="U-${i}.py"
    start_time=$(date +%s.%N)
    output=$(python3 "$script_name" 2>&1)
    end_time=$(date +%s.%N)
    execution_time=$(echo "$end_time - $start_time" | bc)

    # 현재 시간을 포맷팅하여 출력에 추가
    current_datetime=$(date +"%Y-%m-%d %H:%M:%S.%N")
    result_json="{"
    result_json+="\"execution_time\": $execution_time,"
    result_json+="\"date\": \"$current_datetime\","
    result_json+="\"output\": $output"
    result_json+="}"

    echo "$result_json" >> "$RESULTS_PATH"

    if [[ $output == *ERROR* ]]; then
        errors+=("Error executing $script_name: $output")
    else
        results+=("\"$i\": {\"$output\",  $execution_time}")
    fi
done

# 결과를 JSON 파일로 저장
echo "{" > "$RESULTS_PATH"
echo "${results[*]}" | sed 's/} "/}, "/g' >> "$RESULTS_PATH"
echo "}" >> "$RESULTS_PATH"

# 오류가 있으면 로그 파일에 기록
if [ ${#errors[@]} -ne 0 ]; then
    printf "%s\n" "${errors[@]}" > "$ERRORS_PATH"
fi