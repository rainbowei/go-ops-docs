# Java-开发规范-Spring

## 一、引导
本规范包含 Springboot 相关的开发约定、项目的开发规范等。

## 二、配置文件篇
**所有的项目用到的配置文件请遵从以下约定进行管理，有疑问或者有其他建议的请在 FAQ 里进行补充，届时会进行相关的更正。**

```yaml
# 有关启动类，优先加载的配置信息请放到当前配置文件下，除非必要，否则不要将其他信息放到此处。
bootstrap.yml

# 总的配置文件入口，存放通用的配置信息，此信息是各个环境共用的。配置文件的激活也放到此处。
application.yml

# 开发环境配置文件，仅包含开发相关的配置。
application-dev.yml

# 测试环境配置文件，仅包含测试相关的配置。
application-test.yml

# 生产级别的配置文件，仅包含测试相关的配置。
application-pro.yml

# 针对于其他的配置文件信息，请以 yml 的格式创建，不要以 properties 格式创建。
如：config.yml
```

## 三、项目结构篇
对于新项目，请以该 [**模版**](https://dev-git.gaolvzongheng.com/glzh/backend/samples/gl-generic-template/-/tree/develop) 为基础进行搭建；

**项目根路径需要包含的文件**

* .editorconfig
* .gitignore
* Jenkinsfile
* README.md

**所有的子项目需要包含**
* README.md

## 四、命名规范篇

### 4.1 项目命名
对于当前的高旅旗下的项目，请以 "**gl-**" 开头，目前根据不同的使用场景以及业务，已有的命名有：
- gl-bi 该命名下包含的都是基础设施组件，供项目去使用，都是以 jar 包的形式提供支持。
- gl-bs 该命名下包含的都是基础设施服务，需要单独部署，单独运行。
对于其他的业务，需要进行如下命名：**gl-[项目归属 ]-[项目名 ]-[功能 ]**，如：

```
gl-app-user-center
    |---gl-app-user-auth
    |---gl-app-user-bootstrap
    |---gl-app-user-controller
    |---gl-app-user-service
    |---gl-app-user-dao
    |---gl-app-user-common
```

### 4.2 分包
对于单端系统的，这里直接按照模块名（这里以"用户模块"以及"系统模块"为例）进行分包
```
gl-app-user-controller
    |---com.gaolv.controller
        |---user
            |---UserController
        |---system
            |---MenuController
            |---RoleController
            |---PermissionController
```
对于多端系统，需要根据各个客户端分包，然后根据模块分包
```
gl-app-user-controlelr
    |---com.gaolv.controller
        |---app
            |---user
            |---system
        |---background
            |---user
            |---system
        |---wechat
            |---user
```
**注意：针对于服务层或者 Dao 层，不需要区分客户端，所以直接以模块分包即可（因为对于客户端接口的暴露是控制层的责任，服务方无需知道自己的服务对象是谁）**

### 4.3 Maven 命名
* groupId ："com.gaolv"
* artifactId： "**gl-[项目归属 ]-[项目名 ]-[功能 ]**"，名称与项目名保持一致
* version：所有的子模块版本号需要继承父类的版本号（${project.version}）

ps:

**父模块**
```xml
<project>
    <parent>
       <groupId>com.gaolv</groupId>
       <artifactId>gl-bi-parent</artifactId>
       <version>1.0.0-SNAPSHOT</version>
     </parent>

     <artifactId>gl-generic-template</artifactId>
     <version>1.0.0-SNAPSHOT</version>
     <name>gl-generic-template</name>
     <packaging>pom</packaging>
     <description> 通用的项目模版 </description>

    <dependencyManagement>
         <dependencies>
             <!-- 启动类 -->
             <dependency>
                 <groupId>com.gaolv</groupId>
                 <artifactId>gl-generic-bootstrap</artifactId>
                 <version>${project.version}</version>
             </dependency>
         </dependencies>
     </dependencyManagement>
</project>
```
**子模块（无需指定版本号）**
```xml
   <project>
       <parent>
            <groupId>com.gaolv</groupId>
            <artifactId>gl-generic-template</artifactId>
            <version>1.0.0-SNAPSHOT</version>
       </parent>

      <artifactId>gl-generic-bootstrap</artifactId>
      <name>gl-generic-bootstrap</name>
      <description> 系统启动模块 </description>
   </project>
```

## 五、Starter 篇

### 5.1 命名
- 无分级结构：gl-[bi]-[功能 ]-starter
- 分级结构：gl-[bi]-[类别 ]-[功能 ]-starter

### 5.2 结构
```
com.gaolv.[cache].[redis]
    |---config
           |---配置参数文件（[Redis]Config.java）
    |---configuration
           |---配置类（[Redis]Configuration.java）
    |---properties
           |---配置属性文件（[Redis]ConfigurationProperties.java）
    |---[Redis]AutoConfiguration.java
```

## 六、代码规范篇


### 6.1 注释
- 字段注释必须采用文档注释
- 方法注释必须采用文档注释，并且各个参数、异常、返回值需提供详细的说明

### 6.2 响应结果
为了保证一致响应，这里要求所有的响应结果均返回 **ResultRtn** 对象。
ps:
- 请求成功无数据

```java
ResultRtn.of(GenericStatusCode.SUCCESS)
```
- 请求成功有数据返回，支持多种数据集合，多结果返回

```java
ResultRtn.of(GenericStatusCode.SUCCESS, [list、obj、map、set]...)
```
- 带分页的结果返回（分页对象必须放到第二个参数位置）

```java
var userInfoListPages = this.userInfoService.findListByPage(pageNum, pageSize, Map.of());
// 分页信息
var pageInfo = ResultRtn.PageInfo.of(pageNum, pageSize, userInfoListPages.getTotal());
ResultRtn.of(GenericStatusCode.SUCCESS, pageInfo, userInfoListPages)
```
#### 6.2.1 响应码
响应码具体号段分配信息已经集成到了 gl-bi-common 中。
当项目中需要自定义响应码时，需要实现 IStatusCode 接口；

#### 6.2.2 关于异步的使用
- 为了尽快释放掉 Web 服务器的线程以为更多的接口提供服务，这里推荐采用异步的方式进行配置。
- IO 操作、网络调用等场景需要异步操作，如果只是单纯的计算无需使用异步。
ps:
```java
@Autowired
private Executor asyncExecutor;
@Autowired
private UserInfoService userInfoService;
@GetMapping("/info/{pageNum}/{pageSize}")
public DeferredResult<ResultRtn<List<UserInfo>>> findAllByPage(@PathVariable int pageNum, @PathVariable int pageSize) {
    // 创建异步结果集
    var result = new DeferredResult<ResultRtn<List<UserInfo>>>();

    // 开启异步的支持
    CompletableFuture.supplyAsync(() -> {
        var userInfoListPages = this.userInfoService.findListByPage(pageNum, pageSize, Map.of());
        // 分页信息
        var pageInfo = ResultRtn.PageInfo.of(pageNum, pageSize, userInfoListPages.getTotal());

        if (userInfoListPages.isEmpty()) {
            log.warn("空结果集");
            result.setResult(ResultRtn.of(GenericStatusCode.NULL_RESULT));
        } else {
            log.info("查询用户信息成功");
            result.setResult(ResultRtn.of(GenericStatusCode.SUCCESS, pageInfo, userInfoListPages));
        }
        return null;
    }, asyncExecutor).orTimeout(Config.ASYNC_TIMEOUT, Config.ASYNC_TIME_UNIT)
        .exceptionally(e -> {
            log.error("发生异常", e);
            result.setResult(ResultRtn.of(GenericStatusCode.ERROR));
            return null;
        });
    return result;
}
```
注意：关于更多的复杂的使用场景，如异步任务的依赖、异步任务的并发执行不在本规范的讨论范围之内。

#### 6.2.3 关于 Optional 的使用
目前封装的 Service 层均采用 Optional 进行数据的封装，这也是基于 Mybatis 提供的支持。对于 Optional 的使用，将常用的误区进行说明：

**~~错误~~**的使用场景：

```java
if (!Optional.ofNullable(member).isPresent()) {
  return;
}

if(Optional.ofNullable(cityName).isPresent() && !Optional.ofNullable(cityCode).isPresent())
```

不觉得这个跟 if ( obj != null) 很像吗？何必在用 Optional.ofNullable 封装一层呢？
正确的用法：

```java
Optional.ofNullable(member).ifPresent(x -> {
   // you can do what you want
});

Optional.ofNullable(member).map(x -> {
   // 当不为 null 的时候会到这里进行处理
}).orElseGet(() -> {
   // 当数据为 null 的时候到这里进行处理
});
```

直接取值，是否提供默认值以及是否抛出异常需要根据业务自定义
```java
Optional.ofNullable(member).get(); // 不要这么做，为什么？会抛空指针

// 你可以直接取值，可以提供默认值，可以抛出异常，可以自定义异常。具体的使用依据业务决定
Optional.ofNullable(member).orElseGet(Memeber::new);
Optional.ofNullable(member).orElse("");
Optional.ofNullable(new UserInfo()).orElseThrow()
Optional.ofNullable(new UserInfo()).orElseThrow(IndexOutOfBoundsException::new)
```

### 6.3.0 依赖传递
为了尽量避免依赖污染问题，当该模块引入的依赖无需传递的时候，请添加

```xml
<optional>true</optional>
```

## 七、性能篇

### 7.1 Pojo 包装类与 MySQL

数据库在设计字段的时候，数据需要考虑相应的默认值，这个是必要的前提；这样 pojo 类就无需采用对应的包装类。

### 7.2 MySQL 库表设计

## 八、FAQ
