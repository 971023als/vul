#!/bin/bash

hosts_deny_path='/etc/hosts.deny'
hosts_allow_path='/etc/hosts.allow'

# /etc/hosts.deny에 'ALL: ALL' 설정 추가
echo "ALL: ALL" > "$hosts_deny_path"
echo "$hosts_deny_path 파일에 'ALL: ALL' 설정을 추가했습니다."

# /etc/hosts.allow 파일 예시 설정
# 이 부분은 실제 네트워크 환경에 맞게 수정해야 합니다.
# 예: SSH 접속을 허용할 특정 IP 주소를 추가합니다.
echo "sshd: 192.168.1.100" > "$hosts_allow_path"
echo "$hosts_allow_path 파일에 특정 호스트 접속 허용 설정을 추가했습니다."

echo "접속 IP 및 포트 제한 설정이 완료되었습니다."
