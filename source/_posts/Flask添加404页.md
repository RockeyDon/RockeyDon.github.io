---
title: Flask添加404页
date: 2024-05-06 17:52:15
tags: [Flask, View]
categories: [最佳实践]
---

当使用 Flask 时，默认情况下是没有找不到路由的提示的。这在刚开始接触 Flask 时可能会让调试接口变得非常困难。

可以通过手动添加一个特定的视图来改善这个情况，以便在出现路由错误时显示所有当前生效的路由。

```python
from werkzeug.exceptions import NotFound
 
 
@app.errorhandler(NotFound)
def url_not_found(err):
    """处理路由404错误"""
    def list_routes():
        result = []
        for rule in app.url_map.iter_rules():
            methods = ', '.join(rule.methods)
            options = {arg: "[{0}]".format(arg) for arg in rule.arguments}
            if "pk" in options:
                options["pk"] = 1
            url = url_for(rule.endpoint, **options)
            line = urllib.parse.unquote("{:50s} {:20s} {}".format(rule.endpoint, methods, url))
            result.append(line)
        return result
    return dict(code=404, message=str(err), routes=list_routes()), 404
```
