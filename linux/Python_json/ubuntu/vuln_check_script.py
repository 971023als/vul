#!/usr/bin/python3

import subprocess
import json
from datetime import datetime
from crontab import CronTab

# 현재 사용자의 crontab을 로드합니다.
cron = CronTab(user=True)

# 스크립트의 경로입니다.
script_path = '/root/vul/vuln_check_script.py'

# cron 작업이 이미 설정되어 있는지 확인합니다.
job_exists = False
for job in cron:
    if job.command == f'/usr/bin/python3 {script_path}':
        job_exists = True
        break

# cron 작업이 존재하지 않으면 추가합니다.
if not job_exists:
    job = cron.new(command=f'/usr/bin/python3 {script_path}', comment='Daily script execution')
    job.setall('0 0 * * *')
    cron.write()
    print("Cron job has been added successfully.")
else:
    print("Cron job already exists. No action taken.")

# 결과를 저장할 딕셔너리
results = {}
# 오류 로그를 저장할 리스트
errors = []

# 현재 날짜와 시간을 문자열로 가져옵니다.
now = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")

# U-01.py부터 U-72.py까지 순차적으로 실행
for i in range(1, 73):
    script_name = f"U-{i:02d}.py"
    start_time = datetime.now()  # 스크립트 실행 시작 시간
    try:
        # 각 스크립트를 실행하고 JSON 출력을 캡처
        completed_process = subprocess.run(["python3", script_name], check=True, capture_output=True, text=True)
        output = completed_process.stdout
        
        # 출력을 JSON으로 변환하고 결과 딕셔너리에 추가
        result = json.loads(output)
        end_time = datetime.now()  # 스크립트 실행 종료 시간
        execution_time = (end_time - start_time).total_seconds()  # 실행 시간 계산
        results[f"script_{i:02d}"] = {"result": result, "execution_time": execution_time}
    except Exception as e:
        error_message = f"Error executing {script_name}: {e}"
        errors.append(error_message)

# 결과 딕셔너리를 JSON 파일로 저장
json_file_path = f"/var/www/html/results_{now}.json"
with open(json_file_path, "w") as json_file:
    json.dump(results, json_file, indent=4)

# 오류가 있으면 로그 파일에 기록
if errors:
    log_file_path = f"/var/www/html/errors_{now}.log"
    with open(log_file_path, "w") as log_file:
        for error in errors:
            log_file.write(error + "\n")

# HTML 파일 생성
html_file_path = '/var/www/html/index.html'

with open(html_file_path, 'w') as html_file:
    html_content = f"""
<!DOCTYPE html>
<html>
<head>
    <title>Script Execution Results</title>
    <style>
        body {{ font-family: Arial, sans-serif; }}
        pre {{ white-space: pre-wrap; word-wrap: break-word; }}
    </style>
</head>
<body>
    <h1>Script Execution Results</h1>
    <div id="results">
        <pre>{json.dumps(results, indent=4)}</pre>
    </div>
</body>
</html>
"""
    html_file.write(html_content)

print(f"Results saved to {json_file_path}")
if errors:
    print(f"Errors logged to {log_file_path}")
print(f"HTML results page created at {html_file_path}")

