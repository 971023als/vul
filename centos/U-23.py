#!/bin/python3

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

BAR

CODE [U-23] DoS 공격에 취약한 서비스 비활성화

cat << EOF >> $result

[ 양호 ] : DoS 공격에 취약한 echo, discard, daytime, chargen 서비스가 비활성화 된 경우

[ 취약 ] : DoS 공격에 취약한 echo, discard, daytime, chargen 서비스 활성화 된 경우

EOF

BAR

ls /etc/xinetd.d/echo* >/dev/null 2>&1
if [ $? -ne 0 ] ; then
OK /etc/xinetd.d/echo 파일이 존재하지 않습니다.
else
for i in `ls /etc/xinetd.d/echo*`
do
INFO $i 파일이 존재합니다.
if [ `cat $i | grep disable | awk '{print $3}'` = yes ] ; then
OK $i 파일에 대한 서비스가 비활성화 되어 있습니다.
else
WARN $i 파일에 대한 서비스가 활성화 되어 있습니다.
fi
done
fi

ls /etc/xinetd.d/discard* >/dev/null 2>&1
if [ $? -ne 0 ] ; then
OK /etc/xinetd.d/discard 파일이 존재하지 않습니다.
else
for i in `ls /etc/xinetd.d/discard*`
do
INFO $i 파일이 존재합니다.
if [ `cat $i | grep disable | awk '{print $3}'` = yes ] ; then
OK $i 파일에 대한 서비스가 비활성화 되어 있습니다.
else
WARN $i 파일에 대한 서비스가 활성화 되어 있습니다.
fi
done
fi


ls /etc/xinetd.d/daytime* >/dev/null 2>&1
if [ $? -ne 0 ] ; then
OK /etc/xinetd.d/daytime 파일이 존재하지 않습니다.
else
for i in `ls /etc/xinetd.d/daytime*`
do
INFO $i 파일이 존재합니다.
if [ `cat $i | grep disable | awk '{print $3}'` = yes ] ; then
OK $i 파일에 대한 서비스가 비활성화 되어 있습니다.
else
WARN $i 파일에 대한 서비스가 활성화 되어 있습니다.
fi
done
fi

ls /etc/xinetd.d/chargen* >/dev/null 2>&1
if [ $? -ne 0 ] ; then
OK /etc/xinetd.d/chargen 파일이 존재하지 않습니다.
else
for i in `ls /etc/xinetd.d/chargen*`
do
INFO $i 파일이 존재합니다.
if [ `cat $i | grep disable | awk '{print $3}'` = yes ] ; then
OK $i 파일에 대한 서비스가 비활성화 되어 있습니다.
else
WARN $i 파일에 대한 서비스가 활성화 되어 있습니다.
fi
done
fi

cat $result

echo ; echo

if nonexistent_device_files:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-23",
            "위험도": "상",
            "진단 항목": "DoS 공격에 취약한 서비스 비활성화",
            "진단 결과": "취약",
            "현황": " xinted 사용시에 파일의 소유자 및 권한 설정 부족",
            "대응방안": " xinted 사용시에 파일의 소유자 및 권한 설정"
        })
    else:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-23",
            "위험도": "상",
            "진단 항목": "DoS 공격에 취약한 서비스 비활성화",
            "진단 결과": "양호",
            "현황": " xinted 사용시에 파일의 소유자 및 권한 설정 부족",
            "대응방안": "  xinted 사용시에 파일의 소유자 및 권한 설정"
        })

return results