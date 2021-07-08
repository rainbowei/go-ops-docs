> #### 作者：孙科伟
#### [ Django REST framework官方文档](https://www.django-rest-framework.org/#)
## 1 genericsView实现列表页：
#### 1.1 mixin和generics.GenericAPIiview方式组合方式实现：
```python
from .serializer import DeploymentListserializer
from rest_framework import mixins
from rest_framework import generics
class DeploymentList2(mixins.ListModelMixin, generics.GenericAPIView):
    """
     无状态应用列表页
     queryset和serializer_class是固定写法，不可更改，否则会报错
    """
    queryset = Deployment_list.objects.all()
    serializer_class = DeploymentListserializer

    def get(self, request, *args, **kwargs):

        return self.list(request,*args,**kwargs)
```
#### 1.2 ListAPIView方式实现：
```python
from .serializer import DeploymentListserializer
from rest_framework import mixins
from rest_framework import generics
class DeploymentList2(generics.ListAPIView):
    """
     无状态应用列表页
     queryset和serializer_class是固定写法，不可更改，否则会报错
    """
    queryset = Deployment_list.objects.all()
    serializer_class = DeploymentListserializer
```

## 2 分页的实现：
#### 1.1 修改配置文件设置分页：

- 代码内容：
``` python
class DeploymentList2(generics.ListAPIView):
    """
     无状态应用列表页
     queryset和serializer_class是固定写法，不可更改，否则会报错
    """
    queryset = Deployment_list.objects.all()
    serializer_class = DeploymentListserializer
```  
- 修改配置文件setting:
```python
REST_FRAMEWORK = {
'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
'PAGE_SIZE': 10,

}
```
#### 1.2 自定义分页风格：
``` python
from  rest_framework.pagination import PageNumberPagination
class StandardResultsSetPagination(PageNumberPagination):
    page_size = 2     #每页个数
    page_size_query_param = 'page_size' #返回总个数
    page_query_param = 'p'    #标识符
    max_page_size = 1000 #最多返回多少条数据

class DeploymentList2(generics.ListAPIView):
    """
     无状态应用列表页
    """
    queryset = Deployment_list.objects.all()
    serializer_class = DeploymentListserializer
    pagination_class =StandardResultsSetPagination
```