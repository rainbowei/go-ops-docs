> #### 作者：孙科伟
#### [kubenetus 官方文档](https://kubernetes.io/zh/docs/concepts/overview/)
#### [pod生命周期](https://www.cnblogs.com/linuxk/p/9569618.html)
## 1. 资源清单类型：
#### 1.1 名称空间级别：
| 工作负载型资源 | 服务发现| 配置与存储型资源 |特殊类型的存储卷  |
| :-----:|: ----: | :----: |:----:|
| pod| service | volume(存储卷)CSI(容器存储接口)| configmap | 
| replicaset| ingress |  |  secret| 
| deployment| |  | downwardapi（把外部环境中的信息输出给容器） | 
| statefulset|  |  |  | 
| daemonset|  |  |  | 
| job|  |  |  | 
| cronjob|  |  |  | 

#### 1.2集群级型资源：
- namespace
- node
- role
- clusterole
- rolebinging
- clusterRoleBinding
#### 1.3 元数据型资源：
- HPA
- podTemplate
- limitRange

## 2. YML格式：
#### 2.1 基本语法：
- 缩进时不允许tab，只可以空格
- #代表注释
- 缩进多少个空格没关系，只要只同一级别即可。

#### 2.2 支持的数据结构
- 对象：建值对儿对集合，又称hash，字典 
- 数组：序列，列表。
- 纯量：单个，不可再分对值

1. 对象类型实例：
```
name:sunkewei
age:33
```
2. 数组类型实例：
```
animal
\- cat
\- dog
```
数组也可以采用行内表示法：
```
animal: [cat,dog]
```
3. 复合结构，对象和数据对结合：
```
language:
- ruby
- perl
- python
websites:
yaml: yaml.org
ruby: ruby-lang.org
python: python.org
perl: use.perl.org
```
4. 存量式最基本的，不可再分的值：
```
1 字符串 布尔值 整数 浮点数 null
2 时间 日期
#数字
number: 12.30
#布尔型
inset: true
# ‘～’代表null
parent: ~

iso8601: 2012-12-14t21:59:43.10-05:00

date:1976-07-31

```
## 3 常用字段说明：
#### 3.1 常用字段：

|  参数名   | 字段类型|说明 |
|  ----  | ----  | ----------------------|
| version | string | 这里指的数k8s的api版本，目前基本上是v1，可以用kubectl api-version命令查查询|
| king  |string |这里指的是yaml文件定义的资源类型和角色，比如pod  |
| metadata  | object |元数据对象，固定值写metadata  |
| metadata.name | string|元数据对象的名字，这里由我们编写，比如命名pod的名字  |
| metadata.namespace | string | 元数据对象的命名空间，由我们自身定义 |
| spec  | object|  详细定义对象，固定值就写spec|
| spec.containers[]  | list | 这里是spec对象的容器列表定义，是个列表 |
| spec.containers[].name|string |这里定义容器的名字  |
| spec.containers[].image | string | 这里定义要用到的镜像名称|
| spec.containers[].imagepullpolicy  | string| 定义镜像的拉取策略，由always、neverl、ifnotpresent 三个值可选（1）always:意思是每次都尝试从新拉取镜像（2）never：表示仅使用本地镜像（3）ifnotpresent：如果本地由镜像就拉取本地镜像，没有就拉取在线镜像。上面3个值都没有设置的话，默认是always |
| spec.containers[].command[] |list|指定容器的启动命令，因为是数组可以指定多个，不指定则使用镜像打包时使用的启动命令  |
| spec.containers[].args[] | list |指定容器启动命令参数，因素是数组可以指定多个。  |
| spec.containers[].workingDir |string|指定容器的工作目录  |
| spec.containers[].volumeMounts[]  | list |指定容器内部的存储卷配置 | 
|  spec.containers[].volumeMounts[].name  | string | 指定可以容器被挂载的存储卷名称 |
|  spec.containers[].volumeMounts[].mountpath  | string |  指定可以容器被挂载的存储卷路径|
|spec.containers[].volumeMounts[].readonly  | string |设置存储卷路径的读写没收，true或者false，默认为读写模式  |
| spec.containers[].ports[]  | list | 指定容器需要用到的端口列表 |
| spec.containers[].ports[].name  | string | 指定端口名称 |
| spec.containers[].ports[].containerport  | string | 指定容器端口需要监听的端口号|
| spec.containers[].ports[].hostport  | string | 指定容器所在主机需要监听的端口号，默认跟上面containerport相同，注意设置了hostport同一台主机无法启动改容器的相同副本（因为主机端口不能相同，这样会冲突） |
| spec.containers[].ports[].portocol  | string | 指定端口协议，支持tcp和udp，默认是tcp|
| spec.containers[].env[]  | list| 指定容器环境运行前需要设置的环境变量列表 |
| spec.restartpolicy  | string | 定义pod的重启策略，可选值为always，onfailure，默认值是always。 |
| spec.nodeselector | object| 定义node的label过滤标签，以name：value格式指定 |
| spec.imagePullSecrets | object|定义pull镜像时使用secret名称，以name：secretkey格式指定  |
| spec.hostnetwork| boolean  |定义是否使用主机网络模式，默认是false。设置为true表示使用网主机网络，不使用docker网桥，同时设置了true将无法则同一台宿主机上启动第二个副本|

## 4. pod生命周期：
#### 1.1 名称空间级别：
| 工作负载型资源 | 服务发现| 配置与存储型资源 |特殊类型的存储卷  |
| :-----:|: ----: | :----: |:----:|
| pod| service | volume(存储卷)CSI(容器存储接口)| configmap | 
| replicaset| ingress |  |  secret| 
| deployment| |  | downwardapi（把外部环境中的信息输出给容器） | 
| statefulset|  |  |  | 
| daemonset|  |  |  | 
| job|  |  |  | 
| cronjob|  |  |  | 
## 5. initC：
#### 1.1 名称空间级别：
| 工作负载型资源 | 服务发现| 配置与存储型资源 |特殊类型的存储卷  |
| :-----:|: ----: | :----: |:----:|
| pod| service | volume(存储卷)CSI(容器存储接口)| configmap | 
| replicaset| ingress |  |  secret| 
| deployment| |  | downwardapi（把外部环境中的信息输出给容器） | 
| statefulset|  |  |  | 
| daemonset|  |  |  | 
| job|  |  |  | 
| cronjob|  |  |  | 
## 6. 探针：
#### 1.1 名称空间级别：
| 工作负载型资源 | 服务发现| 配置与存储型资源 |特殊类型的存储卷  |
| :-----:|: ----: | :----: |:----:|
| pod| service | volume(存储卷)CSI(容器存储接口)| configmap | 
| replicaset| ingress |  |  secret| 
| deployment| |  | downwardapi（把外部环境中的信息输出给容器） | 
| statefulset|  |  |  | 
| daemonset|  |  |  | 
| job|  |  |  | 
| cronjob|  |  |  | 
## 7. start stop 相位：
#### 1.1 名称空间级别：
| 工作负载型资源 | 服务发现| 配置与存储型资源 |特殊类型的存储卷  |
| :-----:|: ----: | :----: |:----:|
| pod| service | volume(存储卷)CSI(容器存储接口)| configmap | 
| replicaset| ingress |  |  secret| 
| deployment| |  | downwardapi（把外部环境中的信息输出给容器） | 
| statefulset|  |  |  | 
| daemonset|  |  |  | 
| job|  |  |  | 
| cronjob|  |  |  | 