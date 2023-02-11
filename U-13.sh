#!/bin/bash

. function.sh

BAR

CODE [U-13] SUID,SGID,Sticky bit 설정파일 점검 

cat << EOF >> $result

[양호]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우

[취약]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있는 경우

EOF

BAR

# /etc/passwd 파일을 읽고 홈 디렉토리의 압축을 풉니다
passwd_file=$(cat /etc/passwd)

# 라인 구분 기호를 기준으로 출력을 배열로 분할
IFS=$'\n' read -d '' -r -a lines <<< "$passwd_file"

# 배열을 반복하여 각 사용자의 홈 디렉토리 추출
for line in "${lines[@]}"
do
  # 구분 기호 ':'를 사용하여 줄을 필드로 나눕니다
  IFS=':' read -r -a fields <<< "$line"

  # 홈 디렉토리에서 SUID 또는 SGID 권한이 있는 파일 확인
  output=$(find -user root -type f \( -perm -04000 -o -perm -02000 \) -exec ls -al {} \;)

  # 출력을 배열로 분할
  arr=($output)

  # 어레이를 루프하여 각 파일 확인
  for file_line in "${arr[@]}"
  do
    # 파일에 대한 권한, 소유자 및 그룹 추출
    permissions=$(ls -ld "$file_line" | awk '{print $1}')
    owner=$(ls -ld "$file_line" | awk '{print $3}')
    group=$(ls -ld "$file_line" | awk '{print $4}')

    # 파일에 SUID 또는 SGID 사용 권한이 있는지 확인합니다
    if [[ $permissions = *"s"* && $permissions = *"x"* ]]; then
      file=$(echo "$file_line" | awk '{print $9}')
      WARN "$file SUID 권한이 탐지되었습니다"
    elif [[ $permissions = *"s"* && $permissions = *"w"* ]]; then
      file=$(echo "$file_line" | awk '{print $9}')
      WARN "$file SGID 권한이 파일에서 탐지됨"
    else
      OK "$file SUID와 SGID에 대한 설정이 부여"
    fi
  done
done

cat $result

echo ; echo

 
