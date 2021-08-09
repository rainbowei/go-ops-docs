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
```
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
