---
title: ChoiceField
date: 2024-05-06 16:28:23
tags: [Django, Model]
categories: [最佳实践]
---

在Django的Models文件中，有时候会出现数字或字符串类型需要使用枚举值的情况。

Django官方推荐的choice field定义通常如下所示：

```python
from django.db import models
 
class YearInSchool:
    FRESHMAN = 'FR'
    SOPHOMORE = 'SO'
    JUNIOR = 'JR'
    SENIOR = 'SR'
 
 
YEAR_IN_SCHOOL_CHOICES = [
    (YearInSchool.FRESHMAN, 'Freshman'),
    (YearInSchool.SOPHOMORE, 'Sophomore'),
    (YearInSchool.JUNIOR, 'Junior'),
    (YearInSchool.SENIOR, 'Senior'),
]
 
 
class Student(models.Model):
    year_in_school = models.CharField(max_length=2, choices=YEAR_IN_SCHOOL_CHOICES, default=YearInSchool.FRESHMAN)
```

显然，*YEAR_IN_SCHOOL_CHOICES*重新引用了一遍*YearInSchool*是冗余的。

更好的方法是，通过定制元类，使类*YearInSchool*支持按照*YEAR_IN_SCHOOL_CHOICES*的格式遍历其属性，如下所示：

```python
from enum import Enum, EnumMeta
 
 
class ChoiceEnumMeta(EnumMeta):
 
    def __getattribute__(cls, name):
        attr = super().__getattribute__(name)
        if isinstance(attr, Enum):
            return attr.value
        return attr
 
    def __iter__(self):
        return ((tag.value, tag.name) for tag in super().__iter__())
 
 
class ChoiceEnum(Enum, metaclass=ChoiceEnumMeta):
    """
    Enum for Django ChoiceField use.
    """
    pass
 
 
class YearInSchool(ChoiceEnum):
    FRESHMAN = 'FR'
    SOPHOMORE = 'SO'
    JUNIOR = 'JR'
    SENIOR = 'SR'
 
class Student(models.Model):
    year_in_school = models.CharField(max_length=2, choices=YearInSchool, default=YearInSchool.FRESHMAN)
```

这样，无需再单独定义*YEAR_IN_SCHOOL_CHOICES*，而是直接通过*YearInSchool*来获取选项列表。