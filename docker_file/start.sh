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
# 后台启动proxy代理
/usr/local/bin/clash -d /etc/clash/ > /root/clash.log 2>&1 &
source /etc/zsh/basic_profile # 设置环境变量，让所有流量走代理
sleep 2 # 等待代理启动完成
# 安装p10k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
sed -i 's/ZSH_THEME.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
# 移动配置文件
mv /root/terminal/.* /root/
rm -rf /root/terminal/
#重启ssh服务，加载公钥
service ssh start
tail -f /dev/null #防止容器退出