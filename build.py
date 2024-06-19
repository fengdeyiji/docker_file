import argparse
import os
import subprocess
import requests
from bs4 import BeautifulSoup
import re

def DO(cmd : str):
  print("CMD:{}".format(cmd))
  result = subprocess.run(cmd, shell=True, stdout=None, stderr=None, encoding='utf-8')
  assert(result.returncode == 0)
  return result.stdout

def download_llvm():
  url = 'https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LatestRelease/'
  response = requests.get(url) # 使用requests获取网页内容
  response.raise_for_status()  # 确保请求成功
  soup = BeautifulSoup(response.text, 'html.parser')# 使用BeautifulSoup解析网页
  # 查找文件链接，这里假设文件链接都在<a>标签的href属性中
  # 并且过滤掉非文件链接（如目录链接）。您可能需要根据实际网页结构调整选择器
  files = [a['href'] for a in soup.find_all('a', href=True) if a['href'].endswith('tar.xz')]
  for file in files:
    if re.match('.*clang.*llvm.*aarch.*tar.xz', file) is not None:
      DO("wget {}{}".format(url, file))
      break
  return

def download_boost():
  url = 'https://archives.boost.io/release/'
  response = requests.get(url)
  response.raise_for_status()
  soup = BeautifulSoup(response.text, 'html.parser')
  files = [a['href'] for a in soup.find_all('a', href=True) if a['href'].endswith('/') and re.match('[0-9]\.[0-9]+\.[0-9]+/', a['href']) is not None]
  files.sort()
  url = "{}{}source/".format(url, files[-1])
  response = requests.get(url)
  response.raise_for_status()
  soup = BeautifulSoup(response.text, 'html.parser')
  files = [a['href'] for a in soup.find_all('a', href=True) if not a['href'].endswith('/')]
  for file in files:
    if re.match('boost.*\.tar.gz', file) is not None:
      DO("wget {}{}".format(url, file))
      break
  return
  
parser = argparse.ArgumentParser(description='prepare/build/run docker')
parser.add_argument('--prepare', default=False, action='store_true',
                    help='download necessary file from web')
parser.add_argument('--build', default=False, action='store_true',
                    help='generate docker')
parser.add_argument('--run', default=False, action='store_true',
                    help='start run docker background, and could ssh to it')
args = parser.parse_args()

os.chdir("./docker_file")
if args.prepare:
  DO("rm -rf ./boost*.zip")
  DO("rm -rf ./*llvm*.tar.xz")
  DO("cat ~/.ssh/id_rsa.pub > authorized_keys")
  download_llvm() #下载最新版本的llvm
  download_boost() #下载最新版本的boost
if args.build:
  DO("docker container ls -a | grep 'dev' | awk '{print $1}' | xargs docker container stop | xargs docker rm") #如果有正在运行的docker，结束掉
  DO('''docker image ls | grep 'dev' | awk '{print $1":"$2}' | xargs docker image rm''') #删除已有的同名镜像
  DO("docker build -t dev:v2 -f Dockerfile .") #创建新的镜像
if args.run:
  DO("docker run -d --mount type=bind,source=/Users/txw/Desktop/src,target=/root/project -p 1024:22 dev:v2")
  DO('''grep -v "\[127.0.0.1\]:1024" "$HOME/.ssh/known_hosts" > "$HOME/.ssh/known_hosts.tmp"''')
  DO('''mv "$HOME/.ssh/known_hosts.tmp" "$HOME/.ssh/known_hosts"''')