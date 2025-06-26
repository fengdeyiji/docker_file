# MAC OS
因为版权问题，个人开发者的docker DeskTop在公司层面被禁用，使用colima代替。  
```shell
brew install colima
```
启动colima的时候，可以使用启动参数:
```shell
colima start --cpu 6 --memory 15 --edit
#docker:
#   registry-mirrors:
#     -http://yum.tbsite.net/mirrors/
```

# 准备工作
1. 拷贝本机公钥
2. 下载最新版本clang+llvm
3. 下载最新版本boost库
```shell
python3 ./build.py --prepare
```
# 生成docker
首先如果当前有正在运行的同名docker(名带'dev')，则先停止对应docker运行  
然后删除dev相关镜像  
最后采用docker file中描述的内容生成新的dev镜像：
1. 拉取最新ubuntu镜像
2. 配置ssh服务
3. 使用apt安装更新常用开发组件
4. 拷贝本机公钥到docker内，实现免密登陆
5. 拷贝解压llvm
6. 拷贝解压vscode-server常用插件
7. 拷贝解压安装boost
8. 安装xmake构建工具
9. 修改默认shell为zsh
```shell
sudo python3 ./build.py --build
```
# 运行开发环境
1. 后台启动docker
2. 绑定docker上的'/root/project'目录到本机'/Users/txw/Desktop/src'目录
3. 重置本机与127.0.0.1:1024相关的known_hosts
```shell
python3 ./build.py --run
```
docker运行启动后将会执行start.sh脚本，内容包括：
1. 安装oh-my-zsh和p10k（使用国内gitee镜像源）
2. 移动覆盖配置文件.p10k.zsh, .tmux.conf, .zshrc到root用户根目录
3. p10k和tmux的配置风格依自己喜好调整，zshrc中为PATH路径增加了llvm路径以及xmake路径，链接路径增加boost库路径
# 登录环境
```shell
ssh root@127.0.0.1 -p 1024
```
happy coding then！