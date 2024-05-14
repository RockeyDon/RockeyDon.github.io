---
title: postgres踩坑
date: 2024-05-06 22:08:43
tags: [postgres]
categories: [踩坑]
---

# 用户
默认情况下，PostgreSQL 的用户名和密码是 **postgres:postgres**。在使用 `COPY` 命令进行文件导入时，需要注意修改文件的权限以确保数据库用户有权限读取文件。

# 数据目录
在首次启动 PostgreSQL 时，要求数据目录必须是空的。但是如果想要将数据目录纳入 Git 追踪，目录中必须至少包含一个文件。为了解决这个问题，你可以参考[这里](https://stackoverflow.com/a/77820566/15870093)的方法。

具体而言，可以让 Git 追踪目录 A（其中包含了 .gitignore 文件），然后指定 PostgreSQL 使用 A 目录下的 B 目录作为数据目录（PostgreSQL 会自动创建该目录）。这样可以在满足 PostgreSQL 启动要求的同时，也可以将数据目录纳入 Git 追踪。
