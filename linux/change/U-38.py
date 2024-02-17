#!/bin/bash

# Apache 서버 루트 디렉터리 검색 및 불필요한 파일 제거
server_root=$(apache2ctl -V | grep 'SERVER_CONFIG_FILE' | cut -d'=' -f2 | xargs dirname)
unwanted_dirs=("$server_root/manual")

removed_items=()
for dir in "${unwanted_dirs[@]}"; do
    if [ -d "$dir" ]; then
        rm -rf "$dir"
        removed_items+=("$dir")
    fi
done

# 결과 업데이트
if [ ${#removed_items[@]} -gt 0 ]; then
    jq --arg items "${removed_items[*]}" '.현황 += ["제거된 불필요한 파일 및 디렉터리: " + $items] | .진단 결과 = "양호"' $results_file > tmp.$$.json && mv tmp.$$.json $results_file
else
    jq '.진단 결과 = "양호" | .현황 += ["Apache 홈 디렉터리 내 기본으로 생성되는 불필요한 파일 및 디렉터리가 이미 제거되어 있습니다."]' $results_file > tmp.$$.json && mv tmp.$$.json $results_file
fi

# 결과 출력
cat $results_file
