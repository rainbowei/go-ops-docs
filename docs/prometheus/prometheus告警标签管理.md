##### 1  prometheus标签管理：

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

  这里的意思是只保留主机tag_Name中以turkey开头的主机。labelmap

- labelmap





