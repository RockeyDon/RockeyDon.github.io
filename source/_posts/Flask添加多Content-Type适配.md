---
title: Flask添加多Content-Type适配
date: 2024-05-06 17:53:15
tags: [Flask]
categories: [最佳实践]
---

当使用 Flask 时，默认情况下是不支持多Content-Type解析的。可以手动为 Flask 添加一套解析函数。

```python
from flask import request
 
 
content_type = request.content_type.split(';')[0]
if content_type == 'application/json':
    body = request.get_json()
elif content_type == 'application/x-www-form-urlencoded' or content_type == 'multipart/form-data':
    body = dict(request.form)
else:
    raise FError(code=FCode.UnsupportedMedia, msg=f"Request content-type {content_type} not supported")
```
