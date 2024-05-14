---
title: docker踩坑
date: 2024-05-06 20:45:14
tags: [docker]
categories: [踩坑]
---

# 镜像
如果使用ARM芯片，务必要确认自己的镜像架构

默认会尝试拉取ARM的镜像，需要加参数指定x86

```shell
docker pull --platform linux/arm64 alpine:latest
docker build --platform linux/arm64 -t ${tag} -f {file} .
```

对于现有的镜像，没有简便方法查看架构

```shell
docker image inspect --format "{{.ID}} {{.RepoTags}} {{.Architecture}}" $(docker image ls -q)
```

# 容器
容器内*localhost*指向的是容器自己而不是宿主机

# 挂载
应该挂载文件夹，而不是文件。除非这个文件不改动

因为某些软件(如Vim)修改文件时，不会真的修改文件内容，而是创建一个新文件，然后用新的替换旧的。这样就造成docker挂载指针丢失

# 部署
离线使用私有镜像时，注意修改hosts文件，让私有域名指向本机

# 网络
删除docker stack时，docker网络最容易出错。

docker网络会在docker stack删除后自动删除，需要docker network ls确认已删除后才能再次启动stack

如果docker网络删除出错，能看到network id却无法删除，按照以下步骤操作

```shell
docker network inspect <id> or <name>  // 查看删不掉的网络

// 在里面找到所有的container，包括默认那个

// 切断仍在引用网络的容器，以下三个命令都试试
docker network disconnect -f <networkID> <endpointName>
docker network disconnect -f <networkID> <endpointId>
docker network disconnect -f <networkID> <containerId>
// 如果容器还在顺便也删掉
docker network prune // 如果成功会打印此命令移除了哪个network
```

# 层文件
docker镜像添加了一个敏感文件，后面又删掉了，那这个文件能被取到吗？

能。

```shell
// 首先把镜像打包保存
docker save docker/example -o example.tar
// 然后解包
tar xf example.tar
// 得到几个信息文件，和一堆sha名字的文件夹，每个里面有个layer.tar，即每个层
// 逐个继续解包。或者根据文件名找文件
for layer in */layer.tar; do tar -tf $layer | grep 特定文件 && echo $layer; done
```
