#!/bin/bash

# 변수 초기화
results=""
vulnerability_found=false
category="파일 및 디렉토리 관리"
code="U-58"
severity="중"
check_item="홈디렉토리로 지정한 디렉토리의 존재 관리"
status=()
recommendation="홈 디렉터리가 존재하지 않는 계정이 없도록 관리"

# 모든 사용자 계정을 확인
while IFS=: read -r username _ uid _ _ home_dir shell; do
  # 시스템 계정 건너뛰기 및 로그인 쉘 없는 계정 건너뛰기
  if [ "$uid" -ge 1000 ] && [[ "$shell" != *"nologin" ]] && [[ "$shell" != *"false" ]]; then
    # 홈 디렉터리가 존재하지 않거나, 관리자가 아닌 계정의 홈 디렉터리가 '/' 인 경우
    if [ ! -d "$home_dir" ] || { [ "$home_dir" == "/" ] && [ "$username" != "root" ]; }; then
      vulnerability_found=true
      if [ ! -d "$home_dir" ]; then
        status+=("$username 계정의 홈 디렉터리 ($home_dir) 가 존재하지 않습니다.")
      elif [ "$home_dir" == "/" ]; then
        status+=("관리자 계정(root)이 아닌데 $username 계정의 홈 디렉터리가 '/'로 설정되어 있습니다.")
      fi
    fi
  fi
done < /etc/passwd

# 진단 결과 설정
if $vulnerability_found; then
  result="취약"
else
  result="양호"
  status=("모든 사용자 계정의 홈 디렉터리가 적절히 설정되어 있습니다.")
fi

# 결과 출력
echo "분류: $category"
echo "코드: $code"
echo "위험도: $severity"
echo "진단 항목: $check_item"
echo "진단 결과: $result"
echo "현황:"
for i in "${status[@]}"; do
  echo "- $i"
done
echo "대응방안: $recommendation"
