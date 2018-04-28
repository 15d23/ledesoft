#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo ��$(date +%Y��%m��%d��\ %X)��:'
LOG_FILE=/tmp/upload/kp_log.txt
CA_DIR=/tmp/upload/CA/
echo "" > $LOG_FILE

backup() {
	echo_date "��ʼ����֤�飡"
	mkdir -p $KSROOT/webs/files
	
	if [ ! -f $KSROOT/koolproxy/data/private/ca.key.pem ]; then
		echo_date "֤���ļ���$KSROOT/koolproxy/data/private/ca.key.pem �����ڣ�"
		file_found=0
	fi
	if [ ! -f $KSROOT/koolproxy/data/private/base.key.pem ]; then
		echo_date "֤���ļ���$KSROOT/koolproxy/data/private/base.key.pem �����ڣ�"
		file_found=0
	fi
	if [ ! -f $KSROOT/koolproxy/data/certs/ca.crt ]; then
		echo_date "$KSROOT/koolproxy/data/certs/ca.crt �����ڣ�"
		file_found=0
	fi

	if [ "$file_found" == "0" ];then
		echo_date "�˳����ݣ�"
		echo XU6J03M6
		exit 1
	fi

	cd $KSROOT/koolproxy/data
	tar czf /tmp/upload/koolproxyca.tar.gz private/ca.key.pem private/base.key.pem certs/ca.crt 
	cp /tmp/upload/koolproxyca.tar.gz $KSROOT/webs/files/koolproxyca.tar.gz	
	echo_date "֤�鱸�����"
}

restore() {
	if [ -f /tmp/upload/koolproxyCA.tar.gz ];then
		echo_date "��ʼ�ָ�֤�飡"
		mkdir -p $CA_DIR
		cp /tmp/upload/koolproxyCA.tar.gz $CA_DIR
		cd $CA_DIR
		tar xzf $CA_DIR/koolproxyCA.tar.gz
	else
		echo_date "û���ҵ��ϴ���֤�鱸���ļ����˳��ָ���"
		echo XU6J03M6
		exit 1
	fi
	
	mv -f $CA_DIR/* $KSROOT/koolproxy/data
	rm -rf $CA_DIR
	rm -f /tmp/upload/koolproxyCA.tar.gz
	rm -rf /tmp/upload/koolproxyca.tar.gz
	echo_date "֤��ָ��ɹ���"
}

case $2 in
1)
	#����֤��
	backup >> $LOG_FILE
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	sleep 10
	rm -rf /koolshare/webs/files/koolproxyca.tar.gz
	rm -rf /tmp/upload/koolproxyca.tar.gz
	;;
2)
	#�ָ�֤��
	restore >> $LOG_FILE
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	;;
esac

