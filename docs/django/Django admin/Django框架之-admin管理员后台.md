## 1. 基本设置：

#### 1.1 保证路由：

```python
from django.contrib import admin
urlpatterns = [
     path('admin/', admin.site.urls),
]
```

#### 1.2 创建用户：

```python
python manage.py createsuperuser
```

#### 1.3 登陆地址：

```python
http://127.0.0.1:8080/admin
```

#### 1.4 注册模型：





