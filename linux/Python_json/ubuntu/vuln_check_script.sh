#!/bin/bash

# Apache 설치 여부 확인 및 설치
if ! command -v apache2 >/dev/null; then
    echo "Apache is not installed. Installing Apache..."
    sudo apt update
    sudo apt install apache2 -y
else
    echo "Apache is already installed."
fi

# 현재 사용자의 crontab 설정
CRON_JOB="/usr/bin/python3 /root/vul/vuln_check_script.py"
(crontab -l 2>/dev/null | grep -Fq "$CRON_JOB") || (crontab -l 2>/dev/null; echo "0 0 * * * $CRON_JOB # Daily script execution") | crontab -

# 결과 및 오류 로그 저장 경로
RESULTS_PATH="/var/www/html/results_$(date +'%Y-%m-%d_%H-%M-%S').json"
ERRORS_PATH="/var/www/html/errors_$(date +'%Y-%m-%d_%H-%M-%S').log"
HTML_PATH="/var/www/html/index.html"

# 결과 및 오류 초기화
results=()
errors=()

# U-01.py부터 U-72.py까지 실행
for i in $(seq -w 1 72); do
    script_name="U-${i}.py"
    start_time=$(date +%s.%N)

    if output=$(python3 "$script_name" 2>&1); then
        end_time=$(date +%s.%N)
        execution_time=$(echo "$end_time - $start_time" | bc)
        results+=("\"script_$i\": {\"result\": $output, \"execution_time\": $execution_time}")
    else
        errors+=("Error executing $script_name: $output")
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

# HTML 파일 생성
cat > "$HTML_PATH" <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Script Execution Results</title>
    <style>
        body { font-family: Arial, sans-serif; }
        pre { white-space: pre-wrap; word-wrap: break-word; }
    </style>
</head>
<body>
    <h1>Script Execution Results</h1>
    <div id="results">
        <pre>$(cat "$RESULTS_PATH")</pre>
    </div>
</body>
</html>
EOF

echo "Results saved to $RESULTS_PATH"
[ ${#errors[@]} -ne 0 ] && echo "Errors logged to $ERRORS_PATH"
echo "HTML results page created at $HTML_PATH"

# Apache 서비스 재시작
sudo systemctl restart apache2
echo "Apache service restarted."
