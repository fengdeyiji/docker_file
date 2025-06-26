FROM ubuntu:latest
# 更新软件包列表并安装所需的软件包
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.backup \
#     && sed 's/.*archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.backup > /etc/apt/sources.list \
#     && apt update
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.backup \
#     && sed 's/deb.*http.*\//deb \[arch=amd64\] https:\/\/mirrors.tuna.tsinghua.edu.cn\/ubuntu-ports\//g' /etc/apt/sources.list.backup > /etc/apt/sources.list \
#     && apt update
RUN apt update
RUN apt -y install openssh-server vim gcc g++ build-essential cmake ca-certificates git wget zsh unzip coreutils fonts-powerline tmux curl iputils-ping gdb dtrx
# 创建 txw 用户并设置家目录
RUN useradd -m -s /bin/zsh admin
RUN echo 'admin:admin' | chpasswd
# 配置ssh服务
RUN sed -i 's/.*Port.*/Port 22/; s/.*PermitRootLogin.*/PermitRootLogin Yes/; s/.*PubkeyAuthentication.*/PubkeyAuthentication Yes/; s/.*AuthorizedKeysFile.*/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config
# 设置权限
RUN chown -R admin:admin /home/admin
USER admin
WORKDIR /home/admin
# 拷贝文件
# 预先创建目录并设置权限
RUN mkdir -p .local/LLVM \
    && mkdir -p .local/bin \
    && mkdir -p .vscode-server \
    && mkdir -p .ssh
# 切换回root用户进行文件复制
USER root
# 将默认shell更改为zsh
RUN chsh -s /bin/zsh admin \
    && echo "export TERM=xterm" >> /etc/zsh/zshrc
COPY LLVM*.tar.xz .local/LLVM/
COPY vscode/extensions.tar.xz .vscode-server/
COPY boost*.tar.gz .local/
COPY authorized_keys .ssh/
COPY clash clash
RUN cd .local/ \
    && dtrx -n boost*.tar.gz \
    && rm -rf boost*.tar.gz
RUN cd $(echo .local/boost*) \
    && ./bootstrap.sh \
    && ./b2 boost.stacktrace.from_exception=off install
# 启动后重启ssh服务
COPY start.sh /start.sh
RUN chmod +x /start.sh
# 拷贝zsh的默认配置文件
COPY terminal terminal
# 设置目录权限
RUN chown -R admin:admin .local \
    && chown -R admin:admin .vscode-server \
    && chown -R admin:admin .ssh \
    && chown -R admin:admin terminal

# 切换回admin用户
USER admin
# 配置公钥
RUN chmod 700 .ssh \
    && chmod 600 .ssh/authorized_keys
# 解压
RUN cd .local/LLVM/ \
    && dtrx -n LLVM*.tar.xz \
    && rm -rf LLVM*.tar.xz \
    && mv ./LLVM*/* ./
RUN cd .vscode-server/ \
    && dtrx -n extensions.tar.xz \
    && rm -rf extensions.tar.xz
# 安装xmake
RUN curl -fsSL https://xmake.io/shget.text | bash
# # 安装clash
# RUN chmod +x clash/clash \
#     && mkdir -p .local/bin/ \
#     && chmod +x clash/update_subscription.sh \
#     && mv clash/clash .local/bin/clash \
#     && mv clash/basic_profile /etc/zsh/ \
#     && mv clash/ /etc/
# RUN mv /etc/apt/sources.list.backup /etc/apt/sources.list
# Docker启动之后执行该脚本，完成其他工作
USER root
ENTRYPOINT ["/start.sh"]
# 这仅仅是一个声明
EXPOSE 22