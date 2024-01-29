#!/bin/bash

#1) 부팅시 서비스  on : vsftpd ftp 서비스 enable 
#		* 패키지 설치 유무 확인 / systemctl is-enableled telnet.socket
#2) 현재  서비스 기동중인 상태 확인 : telnet 서비스  activate 
#		* systemctl is-active telnet.socket
#3) 사용자 : root 사용자 접근 허용
#		* /etc/securetty



# 변수 설정 및 초기화
Name='FTP'
FtpPKG='vsftpd ftp'
FtpServiceName='vsftpd'
FtpConf1='/etc/vsftpd/ftpusers'
FtpConf2='/etc/vsftpd/user_list'

# 1) 패키지 설치 유무 확인
rpm -q $FtpPKG >/dev/null 2>&1
if [ $? -ne 0 ] ; then
		echo "[ INFO ] 잠시만 기다려 주세요."
		yum install -q -y $FtpPKG >/dev/null 2>&1 
		if [ $? -eq 0 ] ; then
				echo "[ OK ] 패키지가 정상적으로 설치 되어 있습니다"
		else
				echo "[ FAIL ] 텔넷 패키지가 설치되어 있지 않습니다"
				exit 1
		fi
fi


# 2) 서비스  enable 유무 확인
Enabled=`systemctl is-enabled $FtpServiceName`
if [ $Enabled != 'enabled' ] ; then
		systemctl enable $FtpServiceName >/dev/null 2>&1
		echo "[ OK ] $Name 서비스가 enable 되었습니다."
fi


# 3) 서비스 active 유무 확인
Active=`systemctl is-active $FtpServiceName`
if [ $Active != 'active' ] ; then
		systemctl start $FtpServiceName >/dev/null 2>&1
		echo "[ OK ] $Name 서비스가 active 되었습니다."
fi


# 4) 관리자 서비스 접근 가능 설정
egrep -v '^$|^#' $FtpConf1 | grep -q root
if [ $? -eq 0 ] ; then
		sed -i 's/^root/#root/' $FtpConf1
		echo "[ OK ] root 사용자의 접근 허용 설정을 하였습니다."
fi


egrep -v '^$|^#' $FtpConf2 | grep -q root
if [ $? -eq 0 ] ; then
		sed -i 's/^root/#root/' $FtpConf2
		echo "[ OK ] 다음번째 root 사용자의 접근 허용을 하였습니다."
fi