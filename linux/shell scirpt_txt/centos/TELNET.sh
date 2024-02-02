#!/bin/bash

#1) 부팅시 서비스  on : telnet 서비스 enable 
#		* 패키지 설치 유무 확인 / systemctl is-enableled telnet.socket
#2) 현재  서비스 기동중인 상태 확인 : telnet 서비스  activate 
#		* systemctl is-active telnet.socket
#3) 사용자 : root 사용자 접근 허용
#		* /etc/securetty

# 변수 설정 및 초기화
TelnetPKG='telnet-server telnet'
TelnetServiceName=telnet.socket
TelnetConf=/etc/securetty

# 1) 패키지 설치 유무 확인
#		*telnet-server / telnet

rpm -q $TelnetPKG >/dev/null 2>&1
if [ $? -ne 0 ] ; then
		echo "[ INFO ] 잠시만 기다려 주세요."
		yum install -q -y $TelnetPKG >/dev/null 2>&1 
		if [ $? -eq 0 ] ; then
				echo "[ OK ] 패키지가 정상적으로 설치 되어 있습니다"
		else
				echo "[ FAIL ] 텔넷 패키지가 설치되어 있지 않습니다"
				exit 1
		fi
fi


# 2) 텔넷 서비스 enable 유무 확인
Enabled=`systemctl is-enabled $TelnetServiceName`
if [ $Enabled != 'enabled' ] ; then
		systemctl enable $TelnetServiceName >/dev/null 2>&1
		echo "[ OK ] 텔넷 서비스가 enable 되었습니다."
fi


# 3) 텔넷 서비스 active 유무 확인
Active=`systemctl is-active $TelnetServiceName`
if [ $Active != 'active' ] ; then
		systemctl start $TelnetServiceName >/dev/null 2>&1
		echo "[ OK ] 텔넷 서비스가 active 되었습니다."
fi


# 4) 관리자 서비스 접근 가능 설정
grep -q 'pts/' $TelnetConf #-q 옵션은 실행 과정을 생략하고 결과만 보여줌 (/dev/null기능)
if [ $? -ne 0 ] ; then
		for i in $(seq 1 11) ; do echo "pts/$i" >> $TelnetConf ; done
		echo "[ OK ] 관리자 서비스에 접근 가능하도록 설정하였습니다."
fi
