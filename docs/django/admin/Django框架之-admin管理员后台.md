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

- 新建mobile文件内容Users类

```python
from django.db import models
from  django.contrib.auth.models import  AbstractUser
# Create your models here.
class Users(AbstractUser):
    """
    用户信息扩展
    """
    display = models.CharField('显示的中文名', max_length=50, default='')
    mobile = models.CharField('手机号', max_length=64, blank=True)
    feishu_open_id = models.CharField('飞书OpenID', max_length=64, blank=True)
    failed_login_count = models.IntegerField('失败计数', default=0)
    last_login_failed_at = models.DateTimeField('上次失败登录时间', blank=True, null=True)


    class Meta:
        managed = True
        db_table = 'sql_users'
        verbose_name = u'用户管理'
        verbose_name_plural = u'用户管理'
```

- 注册 Users类到admin.py文件。

```python
from django.contrib import admin
from  common.models import Users
from  django.contrib.auth.admin import UserAdmin

# Register your models here.

@admin.register(Users)
class  Useradmin(UserAdmin):

      list_display = ('id','display','username','mobile','email','feishu_open_id' ,'is_superuser', 'is_staff', 'is_active')
      list_display_links = ('id', 'username',)
      search_fields = ('id', 'username', 'display', 'email')
      ordering = ('id',)
      # 编辑页显示内容 
      fieldsets =(
            ('认证信息', {'fields': ('username', 'password')}),
            ('个人信息',{'fields':('display','mobile','email','feishu_open_id')}),
            ('加入日期', {'fields': ('date_joined',)}),
      )

      # 新增页显示内容
      add_fieldsets =(
            ('认证信息', {'fields': ('username', 'password1','password2')}),
            ('个人信息',{'fields':('display','mobile','email','feishu_open_id')}),
            ('加入日期', {'fields': ('date_joined',)}),
      )
```

## 2. models各字段含义：

1. class meta字典：

```
   class Meta:
        managed = True
        db_table = 'sql_users'
        verbose_name = u'用户管理'
        verbose_name_plural = u'用户管理'
```

- db_table: 数据库生产后表的名字

- verbose_name: admin管理后台显示的名称，默认后面会带s；设置 verbose_name_plural = u'用户管理'后可以取消s。

  ![](C:\Users\huawei\Desktop\go-ops-docs\docs\images\image-20210810144809998.png)

2. 内容字段：

   ```python
   display = models.CharField('显示的中文名', max_length=50, default='')
   mobile = models.CharField('手机号', max_length=64, blank=True)
   ```

- display，mobile  ：数据库表的字段名称

- 显示中文名，手机号 ：admin管理后台，打开表后显示的字段名称。如下图：

  

![](C:\Users\huawei\Desktop\go-ops-docs\docs\images\image-20210810145400343.png)

## 3. admin.py注册类含义：

```python
from django.contrib import admin
from  common.models import Users
from  django.contrib.auth.admin import UserAdmin

# Register your models here.

@admin.register(Users)
class  Useradmin(UserAdmin):

      list_display = ('id','display','username','mobile','email','feishu_open_id' ,'is_superuser', 'is_staff', 'is_active')
      list_display_links = ('id', 'username',)
      search_fields = ('id', 'username', 'display', 'email')
      ordering = ('id',)
      # 编辑页显示内容
      fieldsets =(
            ('认证信息', {'fields': ('username', 'password')}),
            ('个人信息',{'fields':('display','mobile','email','feishu_open_id')}),
            ('加入日期', {'fields': ('date_joined',)}),
      )

      # 新增页显示内容
      add_fieldsets =(
            ('认证信息', {'fields': ('username', 'password1','password2')}),
            ('个人信息',{'fields':('display','mobile','email','feishu_open_id')}),
            ('加入日期', {'fields': ('date_joined',)}),
      )
```

- @admin.register(Users) 注册models模型，等价于：admin.register(Users,Useradmin)    

- list_display: admin后台页面要显示的字段列表：如下图：
 ![avatar](../images/image-20210811151750667.png)

- list_display_links: 指定字段，通过字段双击后，可以进入编辑界面。如上图通过点击id和用户名字段，可以进入编辑界面。

- search_fields：指定查询的字段。

- ordering ：指定排序字段。

-    fieldsets：指定编辑区域，其中：认证信息，个人信息，加入日期，为各个字段的分界线。fields后面为各个字段名称，如下图所示：

![image-20210811152315612](C:\Users\huawei\AppData\Roaming\Typora\typora-user-images\image-20210811152315612.png)

add_fieldsets：指定新增页面：其中：认证信息，个人信息，加入日期，为各个字段的分界线。fields后面为各个字段名称，

![image-20210811152550380](C:\Users\huawei\AppData\Roaming\Typora\typora-user-images\image-20210811152550380.png)

