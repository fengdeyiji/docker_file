#!/bin/bash
service ssh restart #重启ssh服务，加载公钥
tail -f /dev/null #防止容器退出