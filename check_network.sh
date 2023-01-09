#!/bin/bash

. functions.sh

# Variable Definitions & Initialization
IP1=172.16.xx.xxx
IP2=168.xxx.xx.x #외부 IP
IP3=www.google.com

# 1) Local Network Check
print_info "[*] ping $IP1"
ping -c 1 $IP1 >/dev/null 2>&1 # 출력내용은 필요없으니 null로
if [ $? -eq 0 ] ; then
		print_good "[ OK ] Local Network Connection"
else
		print_error "[ FAIL ] Local Network Connection"
	cat <<- EOF
	(ㄱ) VMware > Edit > Virtual Network Editor
    (ㄴ) VMware > VM > Settings > Network Adapter
    (ㄷ) # ifconfig 
	EOF
	exit 1 #비정상적으로 종료
fi


# 2) External Network Check
print_info "ping $IP2"
ping -c 1 $IP2 >/dev/null 2>&1
if [ $? -eq 0 ] ; then
		print_good "[ OK ] Local Network Connection"
else
		print_error "[ FAIL ] Local Network Connection"
		echo -e "\t(t) # netstat -nr (# route -n)"
		exit 2
fi


# 3) DNS Check
print_info "ping $IP3"
ping -c 1 $IP3 >/dev/null 2>&1
if [ $? -eq 0 ] ; then
		print_good "[ OK ] DNS Client Configuration"
else
		print_error "[ FAIL ] DNS Client Configuration"
		echo -e "\t(ㄱ) # cat /etc/resolv.conf"
		exit 3
fi







# 3) DNS Check
