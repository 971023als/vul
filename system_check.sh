#!/bin/bash
. function.sh
>$RESULT
CHECK_ERROR=error.txt
>$CHECK_ERROR
NUM=1

for U_NUM in `seq 1 73`
do
	Banner
	. U-$U_NUM.sh
	if [ $? -ne 0 ] ; then
		echo 'U-$U_NUM 검사 오류' >> $CHECK_ERROR
	fi
	clear
done
F_Banner