#!/bin/python3

import re
import json

# Apache 구성 파일 경로 설정
config_file = "/etc/httpd/conf/httpd.conf"

def check_document_root(config_path):
    """
    Apache 구성 파일에서 DocumentRoot 설정을 확인합니다.
    """
    document_root = None
    try:
        with open(config_path, 'r') as file:
            for line in file:
                if line.strip().startswith('DocumentRoot'):
                    document_root = re.findall(r'"(.*?)"', line)[0]
                    break
    except FileNotFoundError:
        return None, "Apache 구성 파일을 찾을 수 없습니다."
    
    if document_root:
        if document_root == "/var/www/html":
            return False, f"DocumentRoot가 기본 경로로 설정되었습니다: {document_root}"
        else:
            return True, f"DocumentRoot가 별도의 경로로 설정되었습니다: {document_root}"
    else:
        return None, "DocumentRoot 설정을 찾을 수 없습니다."

# DocumentRoot 설정 확인
document_root_set, message = check_document_root(config_file)

results = []
diagnostic_item = "웹 서비스(Apache) 영역의 분리"
if document_root_set is True:
    results.append({
        "분류": "서비스 관리",
        "코드": "U-41",
        "위험도": "상",
        "진단 항목": diagnostic_item,
        "진단 결과": "양호",
        "현황": message,
        "대응방안": "현재 DocumentRoot 설정 유지"
    })
elif document_root_set is False:
    results.append({
        "분류": "서비스 관리",
        "코드": "U-41",
        "위험도": "상",
        "진단 항목": diagnostic_item,
        "진단 결과": "취약",
        "현황": message,
        "대응방안": "DocumentRoot를 기본 경로 외의 안전한 경로로 변경"
    })
else:
    results.append({
        "분류": "서비스 관리",
        "코드": "U-41",
        "위험도": "정보 부족",
        "진단 항목": diagnostic_item,
        "진단 결과": "정보 부족",
        "현황": message,
        "대응방안": "Apache 구성 파일 확인 및 DocumentRoot 설정 점검"
    })

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
