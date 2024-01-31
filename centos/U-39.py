#!/bin/python3

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-39] Apache 링크 사용 금지 

cat << EOF >> $result

[양호]: 심볼릭 링크, aliases 사용을 제한한 경우

[취약]: 심볼릭 링크, aliases 사용을 제한하지 않은 경우

EOF

BAR


# Set the Apache2 configuration file path
config_file="/etc/httpd/conf/httpd.conf"

# Use grep to check if the FollowSymLinks and SymLinksIfOwnerMatch options are enabled in the configuration file
symlink_result=$(grep -E "^[ \t]*Options[ \t]+FollowSymLinks" $config_file)
alias_result=$(grep -E "^[ \t]*Options[ \t]+SymLinksIfOwnerMatch" $config_file)

if [ -n "$symlink_result" ] && [ -n "$alias_result" ]; then
    WARN "Apache2에서 심볼릭 링크 및 별칭이 허용됨"
else
    OK "Apache2에서는 심볼릭 링크 및 별칭이 제한됩니다."
fi

 
cat $result

echo ; echo


if nonexistent_device_files:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-38",
            "위험도": "상",
            "진단 항목": "웹 서비스(Apache) 링크 사용 금지",
            "진단 결과": "취약",
            "현황": "웹 디렉터리 내 설정된 FollowSymLinks 옵션을 활성화 상태",
            "대응방안": "웹 디렉터리 내 설정된 FollowSymLinks 옵션을 비활성화"
        })
    else:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-38",
            "위험도": "상",
            "진단 항목": "웹 서비스(Apache) 링크 사용 금지",
            "진단 결과": "양호",
            "현황": "웹 디렉터리 내 설정된 FollowSymLinks 옵션을 비활성화 상태",
            "대응방안": "웹 디렉터리 내 설정된 FollowSymLinks 옵션을 비활성화"
        })

return results
 
