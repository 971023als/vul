#!/bin/bash

# Variables for file paths, ensure these are set before running the script
NOW=$(date +'%Y-%m-%d_%H-%M-%S')
RESULTS_PATH="/var/www/html/results_${NOW}.json"
ERRORS_PATH="/var/www/html/errors_${NOW}.log"
CSV_PATH="/var/www/html/results_${NOW}.csv"
HTML_PATH="/root//vul/linux/Python_json/ubuntu/index.html"

# Initialize result file and error array
echo "[" > "$RESULTS_PATH"
declare -a errors

# Run security check scripts
for i in $(seq -f "%02g" 1 72); do
    SCRIPT_PATH="U-$i.py"
    if [ -f "$SCRIPT_PATH" ]; then
        RESULT=$(python3 "$SCRIPT_PATH" 2>>"$ERRORS_PATH")
        if [ $? -eq 0 ]; then
            [ "$first_entry" != true ] && echo "," >> "$RESULTS_PATH"
            first_entry=false
            echo "$RESULT" >> "$RESULTS_PATH"
        else
            errors+=("Error running $SCRIPT_PATH")
        fi
    else
        errors+=("$SCRIPT_PATH not found")
    fi
done
echo "]" >> "$RESULTS_PATH"

# Log errors if any
if [ ${#errors[@]} -gt 0 ]; then
    printf "%s\n" "${errors[@]}" > "$ERRORS_PATH"
    echo "에러가 존재함 -> $ERRORS_PATH"
else
    echo "에러 없음."
fi

# Generate CSV and HTML from JSON
python3 - <<EOF
import json
import csv
from pathlib import Path

# Use the actual file paths if environment variables are not set
json_path = Path("$RESULTS_PATH")
csv_path = Path("$CSV_PATH")
html_path = Path("$HTML_PATH")

# Convert JSON to CSV
def json_to_csv():
    with json_path.open('r', encoding='utf-8') as json_file, \
         csv_path.open('w', newline='', encoding='utf-8') as csv_file:
        data = json.load(json_file)
        writer = csv.DictWriter(csv_file, fieldnames=data[0].keys())
        writer.writeheader()
        writer.writerows(data)

# Convert JSON to HTML
def json_to_html():
    with json_path.open('r', encoding='utf-8') as json_file, \
         html_path.open('w', encoding='utf-8') as html_file:
        data = json.load(json_file)
        html_file.write(f'<!DOCTYPE html><html><head><title>Results</title></head><body><h1>Analysis Results</h1><a href="{csv_path.name}">Download CSV</a><table>')
        headers = data[0].keys()
        html_file.write(''.join(f'<th>{h}</th>' for h in headers))
        for item in data:
            row = ''.join(f'<td>{item[h]}</td>' for h in headers)
            html_file.write(f'<tr>{row}</tr>')
        html_file.write('</table></body></html>')

json_to_csv()
json_to_html()
EOF


# Apache 서비스 재시작 로직 개선
APACHE_SERVICE_NAME=$(systemctl list-units --type=service --state=active | grep -E 'apache2|httpd' | awk '{print $1}')
if [ ! -z "$APACHE_SERVICE_NAME" ]; then
    sudo systemctl restart "$APACHE_SERVICE_NAME" && echo "$APACHE_SERVICE_NAME 서비스가 성공적으로 재시작되었습니다." || echo "$APACHE_SERVICE_NAME 서비스 재시작에 실패했습니다."
else
    echo "Apache/Httpd 서비스를 찾을 수 없습니다."
fi
