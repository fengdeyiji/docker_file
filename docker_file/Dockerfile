FROM debian
# 拷贝公钥
COPY authorized_keys /root/.ssh/authorized_keys
# 启动后重启ssh服务
COPY start.sh /start.sh
# 安装环境所需的包服务：
# 1，ssh服务
# 2，修改ssh的配置
# 3，vim
RUN apt update \
    && apt -y install openssh-server \
    && sed -i 's/.*Port.*/Port 22/; s/.*PermitRootLogin.*/PermitRootLogin Yes/; s/.*PubkeyAuthentication.*/PubkeyAuthentication Yes/; s/.*AuthorizedKeysFile.*/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config \
    && apt -y install vim \
    && chmod +x /start.sh
# docker启动之后执行该脚本
ENTRYPOINT ["/start.sh"]
# 这仅仅是个声明
EXPOSE 22