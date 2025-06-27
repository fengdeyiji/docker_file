FROM ubuntu:22.04
# 更新软件包列表并安装所需的软件包
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.backup \
#     && sed 's/.*archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.backup > /etc/apt/sources.list \
#     && apt update
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.backup \
#     && sed 's/deb.*http.*\//deb \[arch=amd64\] https:\/\/mirrors.tuna.tsinghua.edu.cn\/ubuntu-ports\//g' /etc/apt/sources.list.backup > /etc/apt/sources.list \
#     && apt update
RUN cp /etc/apt/sources.list /etc/apt/sources.list.backup && \
    sed -i 's@http://archive.ubuntu.com/@http://mirrors.ustc.edu.cn/@g' /etc/apt/sources.list && \
    sed -i 's@http://security.ubuntu.com/@http://mirrors.ustc.edu.cn/@g' /etc/apt/sources.list && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    openssh-server vim gcc g++ build-essential cmake ca-certificates git wget zsh unzip coreutils fonts-powerline tmux curl iputils-ping gdb dtrx sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# 创建 admin 用户并设置密码
RUN useradd -m -s /usr/bin/zsh admin && \
    echo 'admin:admin' | chpasswd && \
    echo 'admin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# # 配置ssh服务
# RUN sed -i 's/.*Port.*/Port 22/; s/.*PermitRootLogin.*/PermitRootLogin Yes/; s/.*PubkeyAuthentication.*/PubkeyAuthentication Yes/; s/.*AuthorizedKeysFile.*/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config
# 配置 SSH 服务
RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's|#AuthorizedKeysFile.*|AuthorizedKeysFile .ssh/authorized_keys|' /etc/ssh/sshd_config && \
    mkdir /run/sshd
# 设置权限
# RUN chown -R admin:admin /home/admin
USER admin
WORKDIR /home/admin
# 预先创建目录并设置权限
RUN mkdir -p .local/LLVM .local/bin .vscode-server .ssh

# 安装 oh-my-zsh 和 p10k 主题 (使用清华源加速)
RUN wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh && \
    sed -i 's/REPO=\${REPO:\-ohmyzsh\/ohmyzsh}/REPO=\${REPO:\-mirrors\/ohmyzsh}/g' ./install.sh && \
    sed -i 's/REMOTE=\${REMOTE:\-https:\/\/github.com\/\${REPO}.git}/REMOTE=\${REMOTE:\-https:\/\/gitee.com\/\${REPO}.git}/g' ./install.sh && \
    sh install.sh --unattended && \
    rm install.sh && \
    cd ~/.oh-my-zsh && \
    git remote set-url origin https://gitee.com/mirrors/oh-my-zsh.git && \
    git pull
# 安装 zsh 插件
RUN git clone https://gitee.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
# 复制 zsh 配置文件
USER root
COPY terminal/.* ./
COPY authorized_keys /home/admin/.ssh/authorized_keys
RUN chown -R admin:admin .
USER admin
RUN chmod 700 /home/admin/.ssh && \
    chmod 600 /home/admin/.ssh/authorized_keys
# 添加环境变量
ENV TERM=xterm-256color
RUN echo 'export TERM=xterm-256color' >> ~/.zshrc

# # 切换回root用户进行文件复制
# USER root
# # # 将默认shell更改为zsh
# # RUN chsh -s /bin/zsh admin \
# #     && echo "export TERM=xterm" >> /etc/zsh/zshrc
# COPY LLVM*.tar.xz .local/LLVM/
# COPY vscode/extensions.tar.xz .vscode-server/
# COPY boost*.tar.gz .local/
# COPY authorized_keys .ssh/
# COPY clash .local/bin/
# # 启动后重启ssh服务
# COPY start.sh /home/admin/start.sh
# RUN chmod +x /home/admin/start.sh
# # 拷贝zsh的默认配置文件
# COPY terminal terminal
# # 设置目录权限
# RUN chown -R admin:admin .

# # RUN cd .local/ \
# #     && dtrx -n boost*.tar.gz \
# #     && rm -rf boost*.tar.gz
# # RUN cd $(echo .local/boost*) \
# #     && ./bootstrap.sh \
# #     && ./b2 boost.stacktrace.from_exception=off install
# # 切换回admin用户
# USER admin
# # 配置公钥
# RUN chmod 700 .ssh \
#     && chmod 600 .ssh/authorized_keys
# 解压
# RUN cd .local/LLVM/ \
#     && dtrx -n LLVM*.tar.xz \
#     && rm -rf LLVM*.tar.xz \
#     && mv ./LLVM*/* ./
# RUN cd .vscode-server/ \
#     && dtrx -n extensions.tar.xz \
#     && rm -rf extensions.tar.xz
# 安装xmake
# RUN curl -fsSL https://xmake.io/shget.text | bash
# # 安装clash
# RUN chmod +x clash/clash \
#     && mkdir -p .local/bin/ \
#     && chmod +x clash/update_subscription.sh \
#     && mv clash/clash .local/bin/clash \
#     && mv clash/basic_profile /etc/zsh/ \
#     && mv clash/ /etc/
# RUN mv /etc/apt/sources.list.backup /etc/apt/sources.list
# Docker启动之后执行该脚本，完成其他工作
# ENTRYPOINT ["tail", "-f", "/dev/null"]
# ENTRYPOINT ["sh", "/home/admin/start.sh", ">/home/admin/start.log", "2>&1"]
# 这仅仅是一个声明
EXPOSE 22
CMD ["sudo", "/usr/sbin/sshd", "-D"]