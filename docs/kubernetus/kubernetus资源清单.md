> #### 作者：孙科伟

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
- cat
- dog
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