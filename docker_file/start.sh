#!/bin/bash
service ssh restart #重启ssh服务，加载公钥
ps -ef | grep 'clash' | grep -v 'grep' | awk '{print $2}' | xargs kill -9 #重启代理
/usr/local/bin/clash -d /etc/clash/ > /dev/null 2>&1 &
tail -f /dev/null #防止容器退出