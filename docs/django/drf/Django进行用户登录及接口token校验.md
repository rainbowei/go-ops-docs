> #### 作者：孙科伟
#### [ 参考文档](https://zhuanlan.zhihu.com/p/258752405)
## 1 版本说明
#### 1.1 版本说明：
- Python：3.8.8
- Django：3.2.3
- djangorestframework：3.12.4
- djangorestframework-jwt：1.11.0
## 2 安装：
#### 2.1 安装相关依赖
``` python
pip install djangorestframework
pip install djangorestframework-jwt
```
## 3 配置settings.py
#### 3.1 配置setting.py
```python
import datetime

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',  # <-- 添加
    'my_app'
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    # 'django.middleware.csrf.CsrfViewMiddleware',  <-- 注释掉
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

REST_FRAMEWORK = {
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated'
    ),
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_jwt.authentication.JSONWebTokenAuthentication',
        'rest_framework.authentication.BasicAuthentication',
        'rest_framework.authentication.SessionAuthentication'
    )
}

JWT_AUTH = {
    # 设置token有效时间
    'JWT_EXPIRATION_DELTA': datetime.timedelta(seconds=60 * 60 * 2)
}
```
## 4 编写views
1、user_login是用户登录验证接口，使用POST请求，成功后返回给前端token。用户名和密码是使用django命令python managy.py createsuperuser创建的。

2、get_info是获取信息接口，使用GET请求，需要携带token才能访问。
```python
import json
from django.http import JsonResponse
from django.contrib.auth import authenticate, login
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework_jwt.authentication import JSONWebTokenAuthentication
from rest_framework_jwt.settings import api_settings

def user_login(request):
    obj = json.loads(request.body)
    username = obj.get('username', None)
    password = obj.get('password', None)

    if username is None or password is None:
        return JsonResponse({'code': 500, 'message': '请求参数错误'})

    is_login = authenticate(request, username=username, password=password)
    if is_login is None:
        return JsonResponse({'code': 500, 'message': '账号或密码错误'})

    login(request, is_login)

    jwt_payload_handler = api_settings.JWT_PAYLOAD_HANDLER
    jwt_encode_handler = api_settings.JWT_ENCODE_HANDLER
    payload = jwt_payload_handler(is_login)
    token = jwt_encode_handler(payload)

    return JsonResponse(
        {
            'code': 200,
            'message': '登录成功',
            'data': {'token': token}
        }
    )


# 下面的3个装饰器全部来自from引用，相当与给接口增加了用户权限校验和token校验
@api_view(['GET'])
@permission_classes((IsAuthenticated,))
@authentication_classes((JSONWebTokenAuthentication,))
def get_info(request):
    data = 'some info'

    return JsonResponse(
        {
            'code': 200,
            'message': '请求成功',
            'data': data
        }
    )
```
## 5 编写urls
```python
from django.urls import path
from my_app import views

urlpatterns = [
    path('userLogin/', views.user_login),
    path('getInfo/', views.get_info)
]
```
## 6 前端如何调用接口
1、前端使用POST方式调用userLogin接口后就获取到了token。

2、接下来使用GET方式调用getInfo接口的时候，需要在Headers里面指定Authorization的值为'JWT ' + token的形式。

比如token = 'abcd123456789'，Authorization的值就是'JWT abcd123456789'，都是字符串格式。