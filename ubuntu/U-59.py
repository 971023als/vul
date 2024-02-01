U_59() {
	echo ""  >> $resultfile 2>&1
	echo "▶ U-59(하) | 2. 파일 및 디렉토리 관리 > 2.20 숨겨진 파일 및 디렉토리 검색 및 제거 ◀"  >> $resultfile 2>&1
	echo " 양호 판단 기준 : 불필요하거나 의심스러운 숨겨진 파일 및 디렉터리를 삭제한 경우" >> $resultfile 2>&1
	if [ `find / -name '.*' -type f 2>/dev/null | wc -l` -gt 0 ]; then
		echo "※ U-59 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
		echo " 숨겨진 파일이 있습니다." >> $resultfile 2>&1
		return 0
	elif [ `find / -name '.*' -type d 2>/dev/null | wc -l` -gt 0 ]; then
		echo "※ U-59 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
		echo " 숨겨진 디렉터리가 있습니다." >> $resultfile 2>&1
		return 0
	else
		echo "※ U-59 결과 : 양호(Good)" >> $resultfile 2>&1$resultfile 2>&1
		return 0
	fi
}