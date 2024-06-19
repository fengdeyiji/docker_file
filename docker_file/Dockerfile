FROM ubuntu:latest
# 更新软件包列表并安装所需的软件包
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.backup \
#     && sed 's/.*archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.backup > /etc/apt/sources.list \
#     && apt update
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.backup \
#     && sed 's/deb.*http.*\//deb \[arch=amd64\] https:\/\/mirrors.tuna.tsinghua.edu.cn\/ubuntu-ports\//g' /etc/apt/sources.list.backup > /etc/apt/sources.list \
#     && apt update
RUN apt update
RUN apt -y install openssh-server vim gcc g++ build-essential cmake ca-certificates git wget zsh unzip coreutils fonts-powerline tmux curl iputils-ping gdb
# 配置ssh服务
RUN sed -i 's/.*Port.*/Port 22/; s/.*PermitRootLogin.*/PermitRootLogin Yes/; s/.*PubkeyAuthentication.*/PubkeyAuthentication Yes/; s/.*AuthorizedKeysFile.*/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config \
    && mkdir -p /root/.ssh \
    && chmod 700 /root/.ssh \
    && touch /root/.ssh/authorized_keys \
    && chmod 600 /root/.ssh/authorized_keys \
    && cat /root/.ssh/authorized_keys >> /etc/ssh/authorized_keys
# 拷贝公钥
COPY authorized_keys /root/.ssh/
# 拷贝clash客户端以及配置文件
COPY clash /root/clash
# dtrx是一个通用解压工具
RUN apt -y install dtrx
# 拷贝llvm（apt源安装的版本不够新，对cpp20的支持有限）
COPY clang*.tar.xz /usr/local/llvm/
RUN cd /usr/local/llvm/ \
    && dtrx -n clang*.tar.xz \
    && rm -rf clang*.tar.xz \
    && mv ./clang*/* ./
# 拷贝vscode的远程插件
COPY vscode/extensions.tar.xz /root/.vscode-server/
RUN cd /root/.vscode-server/ \
    && dtrx -n extensions.tar.xz \
    && rm -rf extensions.tar.xz
# 拷贝安装boost
COPY boost*.tar.gz /usr/local/
RUN cd /usr/local/ \
    && dtrx -n boost*.tar.gz \
    && rm -rf boost*.tar.gz
RUN cd $(echo /usr/local/boost*) \
    && ./bootstrap.sh \
    && ./b2 boost.stacktrace.from_exception=off install
# 安装xmake
RUN curl -fsSL https://xmake.io/shget.text | bash
# 安装clash
RUN chmod +x /root/clash/clash \
    && chmod +x /root/clash/update_subscription.sh \
    && mv /root/clash/clash /usr/local/bin/clash \
    && mv /root/clash/basic_profile /etc/zsh/ \
    && mv /root/clash/ /etc/
# 启动后重启ssh服务
COPY start.sh /start.sh
RUN chmod +x /start.sh
# RUN mv /etc/apt/sources.list.backup /etc/apt/sources.list
# 将默认shell更改为zsh
RUN chsh -s /bin/zsh root \
    && echo "export TERM=xterm" >> /etc/zsh/zshrc
# 拷贝zsh的默认配置文件
COPY terminal /root/terminal
# Docker启动之后执行该脚本，完成其他工作
ENTRYPOINT ["/start.sh"]
# 这仅仅是一个声明
EXPOSE 22