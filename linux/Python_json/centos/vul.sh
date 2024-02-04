#!/bin/bash

. install.sh

. json.sh

# HTML 파일 생성
cat > "$HTML_PATH" <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>주요통신기반시설 취약점 진단</title>
    <meta charset="utf-8">
    <style>
        body { font-family: Arial, sans-serif; text-align: center; } /* 전체 페이지 가운데 정렬 */
        h1 { text-align: center; } /* 제목 가운데 정렬 */
        table { margin: 0 auto; } /* 표 중앙 정렬 */
        pre {
            white-space: pre-wrap;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
    <h1>주요통신기반시설 취약점 진단</h1>
    <div id="results">
        <table border="1">
            <tr>
                <th>순서</th>
                <th>분류</th>
                <th>위험도</th>
                <th>진단항목</th>
                <th>진단결과</th>
                <th>현황</th>
                <th>대응방안</th>
            </tr>
        </table>
    </div>
    <script src="json.js"></script> <!-- 스크립트 파일을 포함합니다 -->
</body>
</html>

EOF

. encode.sh