#!/bin/bash

. install.sh

# 결과 및 오류 로그 저장 경로 설정
NOW=$(date +'%Y-%m-%d_%H')
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

# HTML 파일 생성
cat > "$HTML_PATH" <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>주요통신기반시설 취약점 진단</title>
    <meta charset="utf-8">
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        h1 { text-align: center; }
        table { margin: 0 auto; border-collapse: collapse; }
        th, td { border: 1px solid black; padding: 8px; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>주요통신기반시설 취약점 진단 결과</h1>
    <div id="results">
        <table>
            <tr>
                <th>분류</th>
                <th>코드</th>
                <th>위험도</th>
                <th>진단항목</th>
                <th>진단결과</th>
                <th>현황</th>
                <th>대응방안</th>
            </tr>
            <?php
            // JSON 파일 로드 및 데이터를 PHP 배열로 변환
            $jsonData = file_get_contents($RESULTS_PATH);
            $data = json_decode($jsonData, true);

            foreach ($data as $row):
            ?>
            <tr>
                <td><?= htmlspecialchars($row['분류']) ?></td>
                <td><?= htmlspecialchars($row['코드']) ?></td>
                <td><?= htmlspecialchars($row['위험도']) ?></td>
                <td><?= htmlspecialchars($row['진단항목']) ?></td>
                <td><?= htmlspecialchars($row['진단결과']) ?></td>
                <td><?= htmlspecialchars($row['현황']) ?></td>
                <td><?= htmlspecialchars($row['대응방안']) ?></td>
            </tr>
            <?php endforeach; ?>
        </table>
    </div>
</body>
</html>
EOF

. encode.sh
