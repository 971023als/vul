#!/bin/bash

PermList=perm.list
ResultFile=report.txt
TMP1=/tmp/tmp1

> $ResultFile
> $TMP1


cat $PermList | while read FileName FileAuth FilePermNum FilePermChar
do
		#echo "$FileName : $FilePermNum : $FilePermChar"
		if	[ ! -f $FileName ] ; then 
				echo "[ ERROR ] $FileName not found" >> $ResultFile
				continue
		else
				find $FileName -type f -perm -$FilePermNum -ls \
				| fgrep -v $FilePermChar > $TMP1 
				if [ -s $TMP1 ] ; then
						BadPerm=$(cat $TMP1 | awk '{print $3}')
						echo "[ WARN ] $FilePermNum 이하 : $BadPerm : $FileName" >> $ResultFile
				else
						GoodPerm=$(find $FileName -type f -ls | awk '{print $3}')
						echo "[  OK  ] $FilePermNum 이하 : $GoodPerm : $FileName" >> $ResultFile
				fi
		fi
done	

 
