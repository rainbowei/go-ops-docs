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
- 对象
- 数组
- 纯量



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