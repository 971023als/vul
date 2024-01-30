#!/usr/bin/python3

import grp
import json

# 결과를 저장할 딕셔너리
results = {
    "U-51": {
        "title": "계정이 존재하지 않는 GID 금지",
        "status": "",
        "description": {
            "good": "존재하지 않는 계정에 GID 설정을 금지한 경우",
            "bad": "존재하지 않은 계정에 GID 설정이 되어있는 경우",
        },
        "unnecessary_groups": []
    }
}

# 필요한 그룹 목록 정의
necessary_groups = set([
    "root", "sudo", "sys", "adm", "wheel", "daemon", "bin", "lp", "dbus",
    "rpc", "rpcuser", "haldaemon", "apache", "postfix", "gdm", "adiosl",
    "mysql", "cubrid", "messagebus", "syslog", "avahi", "whoopsie", "colord",
    "systemd-network", "systemd-resolve", "systemd-timesync", "sync", "user",
    # 이하 생략
])

def check_unnecessary_groups():
    all_groups = [g.gr_name for g in grp.getgrall()]
    
    for group in all_groups:
        if group not in necessary_groups:
            results["unnecessary_groups"].append(group)
    
    # 결과 상태 설정
    if results["unnecessary_groups"]:
        results["status"] = "취약"
    else:
        results["status"] = "양호"

# 검사 수행
check_unnecessary_groups()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
