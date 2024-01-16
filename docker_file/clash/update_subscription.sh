#!/usr/bin/env bash
set -e  # 开启错误终止功能
# 订阅链接地址
SUBSCRIBE="https://sub-api.ohmy.cat/sub?target=clash&url=https%3A%2F%2Fsub.qiduo.eu.org%2Flink%2FStMlwl3CAPFInsmZ%3Fmu%3D1%7Chttps%3A%2F%2Fapi.qiduo.eu.org%2Flink%2FStMlwl3CAPFInsmZ%3Fsub%3D3&insert=false&config=https%3A%2F%2Fraw.githubusercontent.com%2FACL4SSR%2FACL4SSR%2Fmaster%2FClash%2Fconfig%2FACL4SSR_NoAuto.ini&emoji=true&list=false&udp=true&tfo=false&expand=true&scv=false&fdn=false&sort=false&clash.doh=true&new_name=true"
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
  if pgrep -x "clash" > /dev/null; then
    ps -ef | grep 'clash' | grep -v 'grep' | awk '{print $2}' | xargs kill -9
  fi
  generate_config /etc/clash/ ${SUBSCRIBE}
  /usr/local/bin/clash -d /etc/clash/ > /dev/null 2>&1 &
fi
