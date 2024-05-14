---
title: 安装Ubuntu
date: 2024-05-06 22:46:48
tags: [Linux]
categories: [软件推荐]
---

# 安装准备
首先，准备一个外接存储设备（如U盘），并将下载的 ISO 镜像刻录至其中。

这个外接存储设备需要长期保留，因为如果系统发生崩溃，你可能需要用它来修复系统。

# 硬盘分区
在进行 Linux 初次安装时，你可以只设置四个挂载点，均使用 ext4 文件系统：

- /boot：存放引导文件。
- /home：用于存放用户文件。
- /usr：存放系统文件。
- /：根目录，除了上述挂载点以外的其他内容。

其中，/boot 可以设置得比较小，而其他挂载点的大小则根据实际需求来划分。

除了上述的挂载点外，不要为 **/var** 设置分区，否则在使用 boot-repair 进行 dpkg 修复时可能会失败。

另外，你还可以设置一个 **swap** 分区（格式为 swap），类似于虚拟内存和休眠存储的功能。它的大小一般应与你的物理内存大小相当即可。

# 显卡驱动
在没有正确安装显卡驱动的情况下，打开系统设置可能会导致屏幕一闪而过变黑，甚至可能导致 GNOME 桌面环境崩溃。

```shell
apt search nvidia-driver
sudo apt update
sudo apt install 名称
```
一旦完成安装，记得关闭自动更新功能，否则系统可能会自动更新并可能损坏显卡驱动。

# 安装Python
在 Ubuntu 18 中，通常只能安装 Python 3.6，而在 Ubuntu 20 中，通常只能安装 Python 3.8。但通过使用 pyenv，你可以轻松安装任意版本的 Python。

首先，你需要下载 pyenv。建议直接从 https://github.com/pyenv/pyenv 下载文件，并将其放置在 ~/.pyenv 路径下。

然后，你需要设置 bash，以便在启动时初始化 pyenv。在 ~/.bashrc 文件的末尾添加以下内容：
```shell
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```
保存并关闭文件。打开一个新的终端窗口，就可以开始使用了。但是请注意，尚不能直接安装 Python，因为这是通过源码安装，下载可能会很困难。

首先，你需要安装编译依赖：
```shell
sudo apt-get install -y gcc make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev
```

然后，从 https://www.python.org/ftp/python/ 下载你需要的 Python 版本（选择 tar.xz 格式），并将其放置在 ~/.pyenv/cache/ 目录下。接着，你可以使用缓存中的文件进行安装。

# 安装双系统
- 请务必避免对 Windows 进行更新、重装或修改引导配置，否则下面的步骤可能失效。
- 在 BIOS 设置中，将启动模式配置为 UEFI，并将 U 盘设置为启动优先。
- 使用刚才制作的启动盘启动计算机，选择 **试用Ubuntu** ，然后按照如下操作：
```shell
sudo add-apt-repository ppa:yannubuntu/boot-repair -y
sudo apt-get update
sudo apt-get install boot-repair -y
```
- 安装完成后，运行 boot-repair 工具。