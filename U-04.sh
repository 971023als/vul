#!/bin/bash

 

 

. function.sh

 
 TMP1=`SCRIPTNAME`.log

> $TMP1

BAR

CODE [U-04] 패스워드 파일 보호

cat << EOF >> $TMP1

[양호]: 쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우

[취약]: 쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않는 경우

EOF

BAR

 

PASSFILE=/etc/passwd

#PASSFILE=passwd

SHADOWFILE=/etc/shadow

#SHADOWFILE=shadow

 
CheckEncryptedPasswd() {
SFILE=$1
# $1$saltkey$encrypted 숫자들은 암호화 알고리즘의 종류
# $2a$saltkey$encrypted
# $5$saltkey$encrypted
# $6$saltkey$encrypted 우리는 6번을 써야함
EncryptedPasswdField=$(grep '^root' $SFILE | awk -F: '{print $2}' | awk -F'$' '{print $2}')
#echo $EncryptedPasswdField
case $EncryptedPasswdField in
	1|2a|5) echo WarnTrue ;;
	6) echo TrueTrue ;;
	*) echo 'None' ;;
esac
}
 

if [ -f $PASSFILE -a -f $SHADOWFILE ] ; then

Ret1=$(CheckEncryptedPasswd $SHADOWFILE)

case $Ret1 in

None) WARN '쉐도우 패스워드를 사용하지만, 패스워드가 암호화 되어 있지 않습니다.' ;;

TrueTrue) OK '쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하고 있습니다.' ;;

WarnTrue) OK '쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하고 있습니다.' INFO 'SHA-512 알고리즘을 사용할 것을 권장합니다.' ;;

*) : ;;

esac

else

WARN "쉐도우 패스워드를 사용하지 않고 있습니다."

fi

 

 

cat $TMP1

echo ; echo
