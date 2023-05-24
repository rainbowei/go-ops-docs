##### 1  prometheus标签管理：

- **标签的作用：**

​         1.  Prometheus中存储的数据为时间序列，是由Metric的名字和一系列的标签(键值对)唯一标识的, 不同的标签代表不同的时间序列，即 通过指定标签查询指定数据 。

​         2. 不同的标签代表不同的时间序列，即通过指定标签查询指定数据。 

​         3.指标+标签实现了查询条件的作用，可以指定不同的标签过滤不同的数据

- **metadata标签：**

  在被监控端纳入普罗米修斯里面定义了一些元数据标签
  在Prometheus所有的Target实例中，都包含一些默认的Metadata标签信息。可以通过Prometheus UI的Targets页面中查看这些实例的Metadata标签的内容：
  • __address__：当前Target实例的访问地址<host>:<port>
  • __scheme__：采集目标服务访问地址的HTTP Scheme，HTTP或者HTTPS
  • __metrics_path__：采集目标服务访问地址的访问路径
  上面这些标签将会告诉Prometheus如何从该Target实例中获取监控数据。除了这些默认的标签以外，我们还可以为Target添加自定义的标签。

​            在Prometheus所有的Target实例中，都包含一些默认的Metadata标签信息。可以通过Prometheus UI的Targets页面中查看这些实例的Metadata标签的内容：在抓取被监控端就会带上这些标签，这些标签就是声明要采集谁，协议是什么，以及暴露的接口是谁。一般来说元标签只是普罗米修斯去使用，我们一般不会让其做什么事情，并且这些标签是不会写到数据库当中的，使用promql是查询不到这些标签的，因为这些标签只是普罗米修斯内部去使用的，不会存储在时序数据库供我们查询




![image-20230524154815538](/Users/sunkewei/Library/Application Support/typora-user-images/image-20230524154815538.png)

默认情况下，当Prometheus加载Target实例完成后，这些Target时候都会包含一些默认的标签：

```
__address__：当前Target实例的访问地址<host>:<port>
__scheme__：采集目标服务访问地址的HTTP Scheme，HTTP或者HTTPS
__metrics_path__：采集目标服务访问地址的访问路径
_param：采集任务目标服务的中包含的请求参数
```

​           上面这些标签将会告诉Prometheus如何从该Target实例中获取监控数据。

- **自定义标签**

  1.  可以自定义标签，有了这些标签可以针对特定的标签去查询，比如根据机房，或者项目查询某些机器

    2.添加的标签越多，查询的维度越细。自定义标签可以在prom  sql里查询出来。另外有时候，我们需要吧某些元数据，在SQl查询出来，也可以通过从新标记标签的方式，从新标记标签。

  ```
    - job_name: 'BJ Linux Server'
      basic_auth:
        username: prometheus
        password: 123456
      static_configs:
      - targets: ['192.168.179.99:9100']
        labels:
          idc: tongniu
          project: www
   
    - job_name: 'Shanghai Linux Server'
      basic_auth:
        username: prometheus
        password: 123456
      static_configs:
      - targets: ['192.168.179.99:9100']
        labels:
          idc: sss
          project: blog
  ```

  



除了这些默认的标签以外，我们还可以为Target添加自定义的标签。一般来说，Target以_作为前置的标签是在系统内部使用的，因此这些标签不会被写入到样本数据中(意味着通过prome sql表达式查询出来的label查不到以__开头的标签)。不过这里有一些例外，例如，我们会发现所有通过Prometheus采集的样本数据中都会包含一个名为instance的标签，该标签的内容对应到Target实例的address。这里实际上是发生了一次标签的重写处理。这种发生在采集样本数据之前，对Target实例的标签进行重写的机制在Prometheus被称为Relabeling。

- **从新标记标签**

  重新标记目的：为了更好的标识监控指标。

  在两个阶段可以重新标记：

  • relabel_configs ： 在采集之前（比如在采集之前重新定义元标签）
  • metric_relabel_configs：在存储之前准备抓取指标数据时，可以使用relabel_configs添加一些标签、也可以只采集特定目标或过滤目标。 已经抓取到指标数据时，可以使用metric_relabel_configs做最后的重新标记和过滤。

  ![20210202103812317](/Users/sunkewei/Desktop/20210202103812317.png)

- Relabel用来重写target的标签.
- 每个Target可以配置多个Relabel动作，按照配置文件顺序应用
- Target包含一些内置的标签（以'__'开头），都可以用于relabel，在relabel时未保留，内置标签将被删除

##### 2  relabel流程

```shell
Target（[source_label,…]） -> relabel ->  Target （[target_label,…]）
```

##### 3 Relabel的配置

```shell
 [ source_labels: '[' <labelname> [, ...] ']' ]
 [ separator: <string> | default = ; ]
 [ target_label: <labelname> ]
 [ regex: <regex> | default = (.*) ]
 [ modulus: <uint64> ]
 [ replacement: <string> | default = $1 ]
 [ action: <relabel_action> | default = replace ]
```

- Relabel的action

|  ACTION   | Regex匹配 | 操作对象   | 重要参数                                  | 描述                                             |
| :-------: | --------- | ---------- | ----------------------------------------- | ------------------------------------------------ |
|   keep    | 标签值    | target     | 源标签、regex                             | 丢弃指定源标签的标签值没有匹配到regex的target    |
|   drop    | 标签值    | target     | 源标签、regex                             | 丢弃指定源标签的标签值匹配到regex的target        |
| labeldrop | 标签名    | label      | Regex                                     | 丢弃匹配到regex 的标签                           |
| Labelkeep | 标签名    | label      | Regex                                     | 丢弃没有匹配到regex 的标签                       |
|  Replace  | 标签值    | Label名+值 | 源标签、目标标签、替换（值）、regex（值） | 更改标签名、更改标签值、合并标签                 |
|  Hashed   | 无        | 标签名+值  | 源标签、hash长度、target标签              | 将多个源标签的值进行hash，作为target标签的值     |
| Label map | 标签名    | 标签名     | regex、replacement                        | Regex匹配名->replacement用原标签名的部分来替换名 |

 replace是缺省action，可以不配置action 使用labeldrop 和labelkeep  Relabel后需要注意保证metrics+labels唯一
 Replacement会用到了正则捕获组，需要自行补充相关知识

##### 4 查看原标签

​       从prometheus-》status-》service Discovery

![image-20230523155650587](/Users/sunkewei/Library/Application Support/typora-user-images/image-20230523155650587.png)

##### 5  prometheus标签管理-举例

- servicemonitor 新增标签：

```
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  annotations:
    meta.helm.sh/release-name: test1
    meta.helm.sh/release-namespace: monitoring
  creationTimestamp: "2023-02-27T07:45:08Z"
  generation: 3
  labels:
    app.kubernetes.io/instance: test1
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: prometheus-mysql-exporter
    app.kubernetes.io/version: v0.14.0
    helm.sh/chart: prometheus-mysql-exporter-1.12.1
  name: test1-prometheus-mysql-exporter
  namespace: monitoring
  resourceVersion: "269422361"
  uid: f5aefabd-e0fd-422a-8598-32404f7dfff9
spec:
  endpoints:
  - relabelings:
    - action: replace                                 // 
      replacement: eks-mysql.test1.bitget.tools       //  会新增，mysql_address:eks-mysql.test1.bitget.tools   
      targetLabel: mysql_address                   //
  - interval: 30s
    path: /metrics
    port: mysql-exporter
    scrapeTimeout: 10s
  namespaceSelector:
    matchNames:
    - monitoring
  selector:
    matchLabels:
      app.kubernetes.io/instance: test1
      app.kubernetes.io/name: prometheus-mysql-exporter
```

-  keep,只保留符合需要的标签

  ```
  - job_name: AWS-EC2
    metrics_path: '/metrics'
    scrape_interval: 10s
    ec2_sd_configs:
      - port: 9100
    relabel_configs:
  
      - source_labels: [__meta_ec2_tag_Name]
        regex: "(turkey.*)"
        action: keep
  ```

  这里的意思是只保留主机tag_Name中以turkey开头的主机。

- labelmap





