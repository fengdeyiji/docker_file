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
/usr/local/bin/clash -d /etc/clash/ > /dev/null 2>&1 &
source /etc/zsh/proxy_profile
sleep 2
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
sed -i 's/ZSH_THEME.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
mv /root/terminal/.* /root/
rm -rf /root/terminal/
service ssh start #重启ssh服务，加载公钥
tail -f /dev/null #防止容器退出