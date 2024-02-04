#!/bin/bash

# 결과 및 오류 로그 저장 경로
NOW=$(date +'%Y-%m-%d_%H-%M-%S')
RESULTS_PATH="/var/www/html/results_${NOW}.json"
ERRORS_PATH="/var/www/html/errors_${NOW}.log"
HTML_PATH="/var/www/html/index.php"

# 초기 JSON 객체 시작
echo "{" > "$RESULTS_PATH"
errors=()

# JSON 파일을 생성하는 Bash 스크립트 부분
for i in $(seq -w 1 72); do
    script_name="U-${i}.py"
    start_time=$(date +%s.%N)
    output=$(python3 "$script_name" 2>&1)
    end_time=$(date +%s.%N)
    execution_time=$(echo "$end_time - $start_time" | bc)

    # output 변수의 내용을 JSON 문자열에 안전하게 포함하기 위한 처리
    # output 값이 비어 있는 경우 빈 문자열을 할당
    if [ -z "$output" ]; then
        output_escaped="\"\""
    else
        output_escaped=$(echo "$output" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
    fi

    # JSON 구조에 output_escaped 값을 포함시키기
    printf "\"$i\": {\"output\": \"%s\", \"execution_time\": \"%f\"},\n" "$output_escaped" "$execution_time" >> "$RESULTS_PATH"
done


# 파일 마지막에 JSON 닫기
sed -i '$ s/,$/\n}/' "$RESULTS_PATH" # 마지막 쉼표를 닫는 중괄호로 안전하게 변경

# 오류가 있으면 로그 파일에 기록
if [ ${#errors[@]} -ne 0 ]; then
    printf "%s\n" "${errors[@]}" > "$ERRORS_PATH"
fi
