import re
import json

# 결과를 저장할 딕셔너리
results = {
    "U-02": {
        "title": "패스워드 복잡성 설정",
        "status": "",
        "description": {
            "good": "영문 숫자 특수문자가 혼합된 8 글자 이상의 패스워드가 설정된 경우.",
            "bad": "영문 숫자 특수문자 혼합되지 않은 8 글자 미만의 패스워드가 설정된 경우."
        },
        "message": ""
    }
}

def check_pass_min_len():
    min_len_required = 8
    login_defs_file = "/etc/login.defs"
    try:
        with open(login_defs_file) as f:
            for line in f:
                if re.match(r'^PASS_MIN_LEN\s+(\d+)', line):
                    min_len = int(re.findall(r'\d+', line)[0])
                    if min_len >= min_len_required:
                        results["U-02"]["status"] = "양호"
                        results["U-02"]["message"] = results["U-02"]["description"]["good"]
                        return
        results["U-02"]["status"] = "취약"
        results["U-02"]["message"] = results["U-02"]["description"]["bad"]
    except FileNotFoundError:
        results["U-02"]["status"] = "오류"
        results["U-02"]["message"] = f"{login_defs_file} 파일을 찾을 수 없습니다."

def check_pam_complexity():
    pam_file = "/etc/pam.d/common-auth"
    expected_options = "password requisite pam_cracklib.so try_first_pass retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1"
    try:
        with open(pam_file) as f:
            content = f.read()
            if expected_options in content:
                results["U-02"]["status"] = "양호"
                results["U-02"]["message"] += " 및 PAM 복잡성 설정이 적절하게 구성됨."
            else:
                results["U-02"]["status"] = "취약"
                results["U-02"]["message"] += " 하지만 PAM 복잡성 설정이 적절하지 않음."
    except FileNotFoundError:
        results["U-02"]["message"] += " 또한, PAM 설정 파일을 찾을 수 없습니다."

# 검사 수행
check_pass_min_len()
check_pam_complexity()

# 결과를 JSON 파일로 저장
with open('U-02.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
