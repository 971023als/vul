#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

> $TMP1  

 

BAR

CODE [U-59] 숨겨진 파일 및 디렉터리 검색 및 제거

cat << EOF >> $result

[양호]: 디렉터리 내 숨겨진 파일을 확인하여, 불필요한 파일 삭제를 완료한 경우

[취약]: 디렉터리 내 숨겨진 파일을 확인하지 않고, 불필요한 파일을 방치한 경우

EOF

BAR

 
# Set the target directory path
target_dir="/"

# Use the find command to search for hidden files and directories
hidden_files=$(find $target_dir -name ".*" -type f)
hidden_directories=$(find $target_dir -name ".*" -type d)

# Iterate through each hidden file and directory
for file in $hidden_files; do
  # check if the hidden file is unnecessary or suspicious
  if [[ "$file" =~ .*/.*/.bash_history ]]; then
    WARN "숨겨진 파일 $file이 불필요하거나 의심스럽다"
  else
    OK "숨겨진 파일 $file이 불필요하거나 의심스러운 경우가 없습니다"
  fi
done

for directory in $hidden_directories; do
  # check if the hidden directory is unnecessary or suspicious
  if [[ "$directory" =~ .*/.*/.ssh ]]; then
    WARN "숨겨진 디렉토리 $directory가 불필요하거나 의심스럽다"
  else
    OK "숨겨진 디렉토리 $directory가 불필요하거나 의심스러운 경우가 없습니다"
  fi
done

cat $TMP1

echo ; echo 

 
