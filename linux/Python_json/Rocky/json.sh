#!/bin/bash

# 결과 및 오류 로그 저장 경로
NOW=$(date +'%Y-%m-%d_%H-%M-%S')
RESULTS_PATH="/var/www/html/results_${NOW}.json"
ERRORS_PATH="/var/www/html/errors_${NOW}.log"
HTML_PATH="/var/www/html/index.php"

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

    # JSON 문자열을 Bash에서 직접 생성할 때 빈 값이 있는 경우를 처리
    output_escaped=$(echo "$output" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

    # output이 비어 있는 경우를 확인하고, 빈 문자열을 할당
    if [ -z "$output_escaped" ]; then
        output_escaped="\"\""
    fi

    printf "\"$i\": {\"output\": %s, \"execution_time\": \"%s\"},\n" "$output_escaped" "$execution_time" >> "$RESULTS_PATH"


    if [[ $output == *ERROR* ]]; then
        errors+=("$script_name: $output")
    fi
done

# 파일 마지막에 JSON 닫기
sed -i '$ s/,$/\n}/' "$RESULTS_PATH" # 마지막 쉼표를 닫는 중괄호로 안전하게 변경

# 오류가 있으면 로그 파일에 기록
if [ ${#errors[@]} -ne 0 ]; then
    printf "%s\n" "${errors[@]}" > "$ERRORS_PATH"
fi
