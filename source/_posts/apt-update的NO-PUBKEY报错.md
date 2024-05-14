---
title: apt update的NO_PUBKEY报错
date: 2024-05-06 22:31:25
tags: [Linux]
categories: [踩坑]
---

在执行 `apt update` 时，有时会遇到以下报错信息：
```shell
The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 1234ABCD
```

通常情况下，我们只需要在更新之前执行以下命令即可解决：
```shell
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1234ABCD
```

但是……这条命令是要调用gpg的，如果没安装，就会失败，并提示安装gnupg/gnupg2

而执行apt install gnupg2安装需要先加key，这就死锁了……


解决思路：加key一定要gpg，但安装gpg可以不用key。

用apt离线安装，先确定发行版本，然后下载一个同版本的普通Linux镜像启动，然后
```shell
apt-get install --download-only gnupg2
```
这样软件和依赖就会被下载到*/var/cache/apt/archives*

然后用tar打包，<span style="color:red">一定不要用zip</span>！因为普通的Linux可能没有zip，如果现在安装，前面下载的包就没了。而且没有gpg的镜像大概率也没有unzip。
```shell
tar –czf package.tar.gz /var/cache/apt/archives/*
```

docker cp从镜像中复制出来，再ADD进原镜像。然后离线安装不用key
```shell
ADD package.tar.gz /opt/gnupg/
RUN dpkg -i /opt/gnupg/archives/*.deb
```

至此，就可以加key再apt update了