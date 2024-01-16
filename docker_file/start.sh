#!/bin/bash
# 设置输出文件名
output_file="/root/start.log"
# 设置set -x的输出前缀
PS4='+$(date "+%Y-%m-%d %T") '
# 将命令输出重定向到文件
exec > >(tee -a "$output_file") 2>&1
# 开启调试模式，输出每条命令
set -x
service ssh stop
# 后台启动proxy代理（M3 pro的mbp芯片架构为aarch64，无法运行amd64的程序，因此不启动代理）
# /usr/local/bin/clash -d /etc/clash/ > /root/clash.log 2>&1 &
# source /etc/zsh/basic_profile # 设置环境变量，让所有流量走代理
# mv /root/clash/update_subscription.sh /etc/cron.daily/ #每日更新订阅链接
# echo "source /etc/zsh/basic_profile" >> /etc/zsh/zshrc #登录时默认使用代理
# sleep 2 # 等待代理启动完成
# 安装oh-my-zsh和p10k（使用gitee版本）
sh -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)"
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
sed -i 's/ZSH_THEME.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
# 移动配置文件
mv /root/terminal/.* /root/
rm -rf /root/terminal/
#重启ssh服务，加载公钥
service ssh start
tail -f /dev/null #防止容器退出