FROM ubuntu:latest
# 启动后重启ssh服务  
COPY start.sh /start.sh
RUN chmod +x /start.sh
# 拷贝公钥
COPY authorized_keys /root/.ssh/
# 拷贝clash客户端以及配置文件
COPY clash /root/clash
# 更新软件包列表并安装所需的软件包
RUN mv /etc/apt/sources.list /etc/apt/sources.list.backup \
    && sed 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.backup > /etc/apt/sources.list \
    && apt update
    # 安装大头儿
RUN apt -y install openssh-server vim build-essential gcc g++ cmake clang ca-certificates git wget zsh unzip coreutils fonts-powerline tmux curl \
    # 配置ssh服务
    && sed -i 's/.*Port.*/Port 22/; s/.*PermitRootLogin.*/PermitRootLogin Yes/; s/.*PubkeyAuthentication.*/PubkeyAuthentication Yes/; s/.*AuthorizedKeysFile.*/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config \
    && mkdir -p /root/.ssh \
    && chmod 700 /root/.ssh \
    && touch /root/.ssh/authorized_keys \
    && chmod 600 /root/.ssh/authorized_keys \
    && cat /root/.ssh/authorized_keys >> /etc/ssh/authorized_keys
    # 安装clash
RUN chmod +x /root/clash/clash
RUN chmod +x /root/clash/update_subscription.sh
RUN mv /root/clash/clash /usr/local/bin/clash
RUN export NO_PROXY="localhost,127.0.0.1"
RUN export "NO_PROXY=\"localhost,127.0.0.1\"" >> etc/profile
RUN mv /root/clash/update_subscription.sh /etc/cron.daily/
RUN mv /root/clash/ /etc/
RUN /usr/local/bin/clash -d /etc/clash/ > /dev/null 2>&1 &
RUN export ALL_PROXY="socks5://127.0.0.1:1080"
RUN echo "ALL_PROXY=\"socks5://127.0.0.1:1080\"" >> etc/profile
RUN export HTTP_PROXY="http://127.0.0.1:8080"
RUN echo "HTTP_PROXY=\"http://127.0.0.1:8080\"" >> etc/profile
RUN export HTTPS_PROXY="http://127.0.0.1:8080"
RUN echo "HTTPS_PROXY=\"http://127.0.0.1:8080\"" >> etc/profile
RUN mv /etc/apt/sources.list.backup /etc/apt/sources.list
#     # 安装bazel构建工具
# RUN wget -O /bazel_installer.sh https://github.com/bazelbuild/bazel/releases/download/3.1.0/bazel-3.1.0-installer-linux-x86_64.sh
# RUN chmod +x /bazel_installer.sh
# RUN /bazel_installer.sh
    # 将默认shell更改为zsh
RUN chsh -s /bin/zsh root
RUN echo "export TERM=xterm" >> /root/.zshrc
    # 安装on-my-zsh以及power-10k
# RUN wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
# RUN sed -i 's/REPO\=.*/REPO\=\$\{REPO:\-mirrors\/oh\-my\-zsh\}/g' install.sh
# RUN sed -i 's/REMOTE\=.*/REMOTE\=\$\{REMOTE\:\-https\:\/\/gitee.com\/\$\{REPO\}\.git\}/g' install.sh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN cd ~/.oh-my-zsh
# RUN git remote set-url origin https://gitee.com/mirrors/oh-my-zsh.git
# RUN git pull
# RUN git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
RUN sed -i 's/ZSH_THEME.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc

# Docker启动之后执行该脚本
ENTRYPOINT ["/start.sh"]
# 这仅仅是一个声明
EXPOSE 22