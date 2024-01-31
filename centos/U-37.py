#!/bin/python3

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-37] Apache 상위 디렉터리 접근 금지 

cat << EOF >> $result

[양호]: 상위 디렉터리에 이동제한을 설정한 경우

[취약]: 상위 디렉터리에 이동제한을 설정하지 않은 경우

EOF

BAR

HTTPD_CONF_FILE="/etc/httpd/conf/httpd.conf"
ALLOW_OVERRIDE_OPTION="AllowOverride AuthConfig"

if [ ! -f "$HTTPD_CONF_FILE" ]; then
    INFO "$HTTPD_CONF_FILE 을 찾을 수 없습니다."
else
    if grep -q "$ALLOW_OVERRIDE_OPTION" "$HTTPD_CONF_FILE"; then
        OK "$HTTPD_CONF_FILE 에서 $ALLOW_OVERRIDE_OPTION 을 찾았습니다."
    else
        WARN "$HTTPD_CONF_FILE 에서 $ALLOW_OVERRIDE_OPTION 을 찾을 수 없습니다."
    fi
fi



cat $result

echo ; echo

 
if nonexistent_device_files:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-37",
            "위험도": "상",
            "진단 항목": "웹 서비스(Apache) 상위 디렉토리 접근 금지",
            "진단 결과": "취약",
            "현황": "사용하고 있는 모든 웹 디렉터리가 상위 디렉터리로의 접근이 가능한 옵션(AllowOverride None)으로 설정되어 있는 상태",
            "대응방안": "사용하고 있는 모든 웹 디렉터리가 상위 디렉터리로의 접근이 불가능하도록 설정"
        })
    else:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-37",
            "위험도": "상",
            "진단 항목": "웹 서비스(Apache) 상위 디렉토리 접근 금지",
            "진단 결과": "양호",
            "현황": "사용하고 있는 모든 웹 디렉터리가 상위 디렉터리로의 접근이 가능한 옵션(AllowOverride None)으로 설정 안되어 있는 상태",
            "대응방안": "사용하고 있는 모든 웹 디렉터리가 상위 디렉터리로의 접근이 불가능하도록 설정"
        })

return results
 
 

