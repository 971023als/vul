#!/bin/bash

. install.sh

# 파일 경로 및 기타 변수 설정

NOW=$(date +'%Y-%m-%d_%H-%M-%S')
RESULTS_PATH="/var/www/html/results_${NOW}.json"
ERRORS_PATH="/var/www/html/errors_${NOW}.log"
CSV_PATH="/var/www/html/results_${NOW}.csv"
HTML_PATH="/var/www/html/index.html"

# 결과 파일 초기화 및 시작 배열 마크업 작성
echo "[" > "$RESULTS_PATH"
first_entry=true

# 오류 저장 배열 초기화
declare -a errors

# U-01.py부터 U-72.py까지 실행
for i in $(seq -f "%02g" 1 72)
do
    SCRIPT_PATH="U-$i.py"
    if [ -f "$SCRIPT_PATH" ]; then
        # Python 스크립트 실행하고 변수에 결과 저장
        RESULT=$(python3 "$SCRIPT_PATH" 2>>"$ERRORS_PATH") # Python3으로 변경
        if [ $? -eq 0 ]; then
            # 첫 번째 항목이 아니라면, 배열 항목 구분을 위한 쉼표 추가
            if [ "$first_entry" = true ]; then
                first_entry=false
            else
                echo "," >> "$RESULTS_PATH"
            fi
            # 결과 출력
            echo "$RESULT" >> "$RESULTS_PATH"
        else
            errors+=("Error running $SCRIPT_PATH")
        fi
    else
        errors+=("$SCRIPT_PATH not found")
    fi
done

# 배열 닫기
echo "]" >> "$RESULTS_PATH"

# 오류 로그 기록
if [ ${#errors[@]} -gt 0 ]; then
    printf "%s\n" "${errors[@]}" > "$ERRORS_PATH"
    echo "오류가 $ERRORS_PATH에 기록되었습니다."
else
    echo "오류 로그가 없습니다."
fi

echo "결과가 $RESULTS_PATH에 저장되었습니다."


. json.sh


echo "결과가 $CSV_PATH 및 $HTML_PATH에 저장되었습니다."

echo "작업이 완료되었습니다. 결과가 CSV 파일로 저장되었으며, HTML 페이지가 생성되었습니다."

# Apache 서비스 재시작 로직 개선
APACHE_SERVICE_NAME=$(systemctl list-units --type=service --state=active | grep -E 'apache2|httpd' | awk '{print $1}')
if [ ! -z "$APACHE_SERVICE_NAME" ]; then
    sudo systemctl restart "$APACHE_SERVICE_NAME" && echo "$APACHE_SERVICE_NAME 서비스가 성공적으로 재시작되었습니다." || echo "$APACHE_SERVICE_NAME 서비스 재시작에 실패했습니다."
else
    echo "Apache/Httpd 서비스를 찾을 수 없습니다."
fi

. encode.sh
