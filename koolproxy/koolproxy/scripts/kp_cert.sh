#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo ��$(date +%Y��%m��%d��\ %X)��:'
LOG_FILE=/tmp/upload/kp_log.txt
CA_DIR=/tmp/upload/CA/

backup() {
	if [ ! -f $KSROOT/koolproxy/data/private/ca.key.pem ]; then
		exit 1
	fi
	if [ ! -f $KSROOT/koolproxy/data/private/base.key.pem ]; then
		exit 1
	fi
	if [ ! -f $KSROOT/koolproxy/data/certs/ca.crt ]; then
		exit 1
	fi

	cd $KSROOT/koolproxy/data
	tar czf /tmp/upload/koolproxyca.tar.gz private/ca.key.pem private/base.key.pem certs/ca.crt 
}

restore() {
if [ -f /tmp/upload/koolproxyCA.tar.gz ]; then
	mkdir -p $CA_DIR
	cp /tmp/upload/koolproxyCA.tar.gz $CA_DIR
	cd $CA_DIR
	tar xzf $CA_DIR/koolproxyCA.tar.gz
else
	return 0
fi

mv -f $CA_DIR/* $KSROOT/koolproxy/data
rm -rf $CA_DIR
rm -f /tmp/upload/koolproxyCA.tar.gz
sleep 5
rm -rf $KSROOT/koolproxy/data/koolproxyCA.tar.gz
}

case $2 in
1)
	#����֤��
	mkdir -p $KSROOT/webs/files
	backup
	cp /tmp/upload/koolproxyca.tar.gz $KSROOT/webs/files/koolproxyca.tar.gz	
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	sleep 10
	rm -rf /koolshare/webs/files/koolproxyca.tar.gz
	rm -rf /tmp/upload/koolproxyca.tar.gz
	;;
2)
	#�ָ�֤��
	restore
	;;
esac