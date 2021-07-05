> #### 作者：孙科伟
#### [ Django REST framework官方文档](https://www.django-rest-framework.org/#)
## 1.使用Django REST framework：
#### 1.1 Django REST framework安装：
```
pip install djangorestframework
pip install markdown       
pip install django-filter  
```
#### 1.2配置到app：
```
INSTALLED_APPS = [
    ....
    'rest_framework',
]
``` 
#### 1.3配置到docs文档：
```
from  rest_framework.documentation import  include_docs_urls
urlpatterns = [
    path('docs/',include_docs_urls(title='我的项目'))

]

```

#### 1.4 编写接口：
- .serializer文件内容：
  文件中的name，status，number，version，image_url等字段要和models中定义的要一致。
  ``` python
  from  rest_framework import  serializers
     class  DeploymentListserializer(serializers.Serializer):
             name=serializers.CharField(required=True,max_length=100)
             status=serializers.CharField(max_length=10)
             number=serializers.IntegerField(default=0)
             version=serializers.CharField(required=True,max_length=40)
             image_url=serializers.CharField(required=True,max_length=200)

  ```
- views文件内容
``` python
from .models import Deployment_list
from .serializer import DeploymentListserializer
from rest_framework.views import APIView
from rest_framework.response import Response
class DeploymentList(APIView):
    """
     获取deployment列表信息
    """
    def get(self, request, format=None):
        deployment_list = Deployment_list.objects.all()
        deployment_serializer = DeploymentListserializer(deployment_list, many=True)
        return Response(deployment_serializer.data)
```
- 配置urls路由信息：
  ```python
  from  deployment import  views
  urlpatterns = [
    path('deployment/',views.DeploymentList.as_view(),name='无状态应用列表')

]

  ```