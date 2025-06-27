import argparse
import os
import subprocess


def DO(cmd: str):
    print("CMD:{}".format(cmd))
    result = subprocess.run(cmd, shell=True, stdout=None,
                            stderr=None, encoding='utf-8')
    assert (result.returncode == 0)
    return result.stdout


parser = argparse.ArgumentParser(description='prepare/build/run docker')
parser.add_argument('--prepare', default=False, action='store_true',
                    help='download necessary file from web')
parser.add_argument('--llvm_url', default=None, type=str,
                    help='download llvm url(advise:https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LatestRelease/)')
parser.add_argument('--boost_url', default=None, type=str,
                    help='download llvm url(advise:https://archives.boost.io/release/)')
parser.add_argument('--build', default=False, action='store_true',
                    help='generate docker')
parser.add_argument('--run', default=False, action='store_true',
                    help='start run docker background, and could ssh to it')
args = parser.parse_args()

os.chdir("./docker_file")
if args.prepare:
    if args.llvm_url is None or args.boost_url is None:
    print("need url to download llvm and boost, see --help to get the right url")
    exit(0)
    DO("rm -rf ./boost*")
    DO("rm -rf ./*LLVM*")
    DO(f"wget {args.llvm_url}")
    DO(f"wget {args.boost_url}")
    DO("cat ~/.ssh/id_rsa.pub > authorized_keys")
if args.build:
    # 如果有正在运行的docker，结束掉
    DO("docker container ls -a | grep 'dev' | awk '{print $1}' | xargs -r docker container stop | xargs -r docker rm")
    DO('''docker image ls | grep 'dev' | awk '{print $1":"$2}' | xargs -r docker image rm''')  # 删除已有的同名镜像
    DO("docker build -t dev:v2 -f Dockerfile .")  # 创建新的镜像
if args.run:
    DO("docker run -d --mount type=bind,source=$HOME/Desktop/src,target=/home/admin/project -p 1024:22 dev:v2")
    DO('''grep -v "\[127.0.0.1\]:1024" "$HOME/.ssh/known_hosts" > "$HOME/.ssh/known_hosts.tmp"''')
    DO('''mv "$HOME/.ssh/known_hosts.tmp" "$HOME/.ssh/known_hosts"''')
