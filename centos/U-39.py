#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 리스트
results = []

# Apache 구성 파일 경로 설정
config_file = "/etc/httpd/conf/httpd.conf"

def check_link_restrictions():
    """
    Apache 구성 파일에서 심볼릭 링크 및 별칭 사용 제한 설정을 확인합니다.
    """
    try:
        # 구성 파일에서 'Options FollowSymLinks'와 'Options SymLinksIfOwnerMatch' 지시어를 검색
        symlink_result = subprocess.run(["grep", "-E", "Options[ \t]+FollowSymLinks", config_file], capture_output=True, text=True)
        alias_result = subprocess.run(["grep", "-E", "Options[ \t]+SymLinksIfOwnerMatch", config_file], capture_output=True, text=True)
        
        # 둘 다 활성화되어 있으면 True, 그렇지 않으면 False 반환
        if symlink_result.stdout and alias_result.stdout:
            return True
        else:
            return False
    except Exception as e:
        return None  # 오류 발생 시 None 반환

# 심볼릭 링크 및 별칭 사용 제한 설정 확인
link_restriction_enabled = check_link_restrictions()

diagnostic_item = "웹 서비스(Apache) 링크 사용 금지"
if link_restriction_enabled is True:
    status = "취약"
    situation = "Apache에서 심볼릭 링크 및 별칭이 허용됩니다."
    countermeasure = "웹 디렉터리 내 설정된 FollowSymLinks 및 SymLinksIfOwnerMatch 옵션을 비활성화"
elif link_restriction_enabled is False:
    status = "양호"
    situation = "Apache에서 심볼릭 링크 및 별칭 사용이 제한됩니다."
    countermeasure = "현재 상태 유지"
else:
    status = "정보 부족"
    situation = f"{config_file} 파일 검사 중 오류 발생"
    countermeasure = "구성 파일 검사 및 필요한 설정 적용"

results.append({
    "분류": "서비스 관리",
    "코드": "U-39",
    "위험도": "상",
    "진단 항목": diagnostic_item,
    "진단 결과": status,
    "현황": situation,
    "대응방안": countermeasure
})

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
