
# 生成docker
```shell
cd ./docker_file/
cp ~/.ssh/id_rsa.pub authorized_keys #提供公钥，将会被拷贝进docker的ssh的配置中
docker build -t dev:v1 . #制作docker
```
# 运行开发环境
```shell
docker run -d --mount type=bind,source=/Users/txw/Desktop/src,target=/usr/share/src -p 127.0.0.1:5000:22 dev:v1 #后台运行docker
```
happy coding then！