#!/bin/bash
cd `dirname $0`
if [ $# -lt 4 ]; then
	echo usage:$0 LOCAL_PORT REMOTE_PORT REMOTE_USER REMOTE_HOST 
	exit
fi
LOCAL_PORT=$1
REMOTE_PORT=$2
REMOTE_USER=$3
REMOTE_HOST=$4

LOCAL_ADDR=`ip addr|grep "inet "|grep -v "127.0.0.1"|awk '{print $2}'|awk -F/ '{print $1}'|head -n 1`
conn_num=`netstat -tunpa|grep "$LOCAL_ADDR"|grep "$REMOTE_HOST:22"|wc -l`
if [ $conn_num -ge 1 ];then
	echo "testing remote port $REMOTE_HOST:$REMOTE_PORT"
	./test_port $REMOTE_HOST $REMOTE_PORT 500|grep -q "port is open"
	if [ $? -eq 0 ];then
		echo "[`date +"%F %T"`] check forwarding ok."
		exit
	fi
	echo "[`date +"%F %T"`] check forwarding fail."
else
	echo "[`date +"%F %T"`] check forwarding fail."
fi

exec expect auto_forward_local_22.exp $LOCAL_PORT $REMOTE_PORT $REMOTE_USER $REMOTE_HOST

