#!/usr/bin/env bash
set -e  # 开启错误终止功能
# 订阅链接地址
SUBSCRIBE="https://api.nexconvert.com/sub?target=clash&url=https%3A%2F%2Fsupport.tagsssubscribe.com%2Fapi%2Fv1%2Fclient%2Fsubscribe%3Ftoken%3Dd9ccb83fdb3f19f8548db78e7a0161ef&insert=false&emoji=true&list=false&tfo=false&scv=false&fdn=false&sort=false&new_name=true"
if [ -z "${SUBSCRIBE}" ]; then
  echo "Subscription address cannot be empty"
  exit 1
fi

generate_config() {
  wget --no-proxy -O $1/config.yaml $2
  sed -i.bak 's/^port\:.*/port\: 8080/' $1/config.yaml
  sed -i.bak 's/^socks\-port\:.*/socks\-port\: 1080/' $1/config.yaml
  rm -rf $1/config.yaml.bak
}

if [ $# -ne 0 ] && [ "$1" == "boot" ]; then
  generate_config ./clash/ ${SUBSCRIBE}
else
  ps -ef | grep 'clash' | grep -v 'grep' | awk '{print $2}' | xargs kill -9
  generate_config /etc/clash/ ${SUBSCRIBE}
  /usr/local/bin/clash -d /etc/clash/ > /dev/null 2>&1 &
fi