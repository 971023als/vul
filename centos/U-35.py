#!/bin/python3
 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1  

 

BAR

CODE [U-35] Apache 디렉터리 리스팅 제거

cat << EOF >> $result

[양호]: 디렉터리 검색 기능을 사용하지 않는 경우

[취약]: 디렉터리 검색 기능을 사용하는 경우

EOF

BAR



# Apache2 구성 파일 경로 설정
config_file="/etc/httpd/conf/httpd.conf"

# grep을 사용하여 구성 파일에서 디렉토리 목록이 사용 가능한지 확인합니다
Result=$(grep -E "^[ \t]*Options[ \t]+Indexes" $config_file)

if [ -n "$Result" ]; then
    WARN "Apache2 서버에서 디렉터리 목록이 사용 가능합니다."
else
    OK "Apache2 서버에서 디렉터리 목록이 사용 가능하지 않습니다."
fi


cat $result

echo ; echo

if nonexistent_device_files:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-35",
            "위험도": "상",
            "진단 항목": "웹 서비스(Apache) 디렉토리 리스팅 제거",
            "진단 결과": "취약",
            "현황": "웹 디렉터리 내 설정된 Indexes 옵션을 활성화 되어 있는 상태",
            "대응방안": "웹 디렉터리 내 설정된 Indexes 옵션을 비활성화"
        })
    else:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-35",
            "위험도": "상",
            "진단 항목": "웹 서비스(Apache) 디렉토리 리스팅 제거",
            "진단 결과": "양호",
            "현황": "웹 디렉터리 내 설정된 Indexes 옵션을 비활성화 되어 있는 상태",
            "대응방안": "웹 디렉터리 내 설정된 Indexes 옵션을 비활성화"
        })

return results