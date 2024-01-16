set -e  # 开启错误终止功能
for arg in "$@"; do
  if [ "$arg" = "prepare" ]; then
    # sh ./clash/update_subscription.sh "boot"
    cat ~/.ssh/id_rsa.pub > authorized_keys #拷贝本物理机的公钥
    if [ ! -f "llvm.tar.xz" ]; then
      echo "llvm文件不存在, 开始下载"
      wget -O llvm.tar.xz https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LatestRelease/clang%2Bllvm-17.0.6-aarch64-linux-gnu.tar.xz
    fi
  fi
  if [ "$arg" = "build" ]; then
    docker container ls -a | grep 'dev' | awk '{print $1}' | xargs docker container stop | xargs docker rm #如果有正在运行的docker，结束掉
    docker image ls | grep 'dev' | awk '{print $1":"$2}' | xargs docker image rm #删除已有的同名镜像
    docker build -t dev:v1 . #创建新的镜像
  fi
  if [ "$arg" = "run" ]; then
    docker run -d --mount type=bind,source=/Users/txw/Desktop/src,target=/root/project -p 1024:22 dev:v1
    grep -v "\[127.0.0.1\]:1024" "$HOME/.ssh/known_hosts" > "$HOME/.ssh/known_hosts.tmp"
    mv "$HOME/.ssh/known_hosts.tmp" "$HOME/.ssh/known_hosts"
  fi
done