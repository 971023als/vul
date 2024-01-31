#!/bin/python3

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1  
 

BAR

CODE [U-26] automountd 제거 '확인 필요'

cat << EOF >> $result

[양호]: automountd 서비스가 비활성화 되어있는 경우

[취약]: automountd 서비스가 활성화 되어있는 경우

EOF

BAR

status=$(ps -ef | grep automount | awk '{print $1}')

if [ "$status" = "online" ]; then
  WARN "Automount 서비스가 실행 중입니다"
else
  OK "Automount 서비스가 실행되고 있지 않습니다."
fi
 

cat $result

echo ; echo

if nonexistent_device_files:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-26",
            "위험도": "상",
            "진단 항목": "automountd 제거",
            "진단 결과": "취약",
            "현황": " OS는 로컬 디스크를 마운트하여 사용 중에 있으며, automount 데몬은 활성화되어 있어서 불안전한 상태",
            "대응방안": " automountd 제거"
        })
    else:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-26",
            "위험도": "상",
            "진단 항목": "automountd 제거",
            "진단 결과": "양호",
            "현황": "  OS는 로컬 디스크를 마운트하여 사용 중에 있으며, automount 데몬은 활성화되어 있지 않아 안전한 상태",
            "대응방안": "automountd 제거"
        })

return results