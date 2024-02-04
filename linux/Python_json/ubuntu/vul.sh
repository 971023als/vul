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
            <?php foreach ($data as $row): ?>
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
            <?php endforeach; ?>
        </table>
    </div>
</body>
</html>

EOF

. encode.sh