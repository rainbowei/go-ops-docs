###### 1  配置prometheus告警规则目录：

- 总结整个告警系统工作流程：


1）制定prometheus告警规则，当监控指标触发告警规则时，向altermanger发送告警；

2）altermanger接收prometheus发送的告警，管理告警信息，通过分组、静默、抑制、聚合等处理，将告警通过路由发送到对应的接收器上，按不同的规则发送给不同的模块负责人，支持邮件、salck及webhook（对接企业微信/钉钉/飞书）方式发送告警通知。

- 配置高级规则目录

  创建rules目录，用于统一存放告警规则

```yaml
# 在prometheus根目录下创建rules目录
mkdir -p /usr/local/prometheus/rules
 
# 配置prometheus.yml rule_files路径
# vim /usr/local/prometheus/prometheus.yml
 
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).
 
# Alertmanager configuration
alerting:   # 增加alertmanager配置
  alertmanagers:
    - static_configs:
        - targets: ['localhost:9093']
# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files: # 配置告警规则目录
  - rules/*.yml
```

- 重启prometheus生效规则：

```cobol
# 热重载
curl -X POST http://127.0.0.1:9090/-/reload
```

###### 2  配置prometheus告警规则目录：

告警规则示例以服务器资源监控指标为准，包括主机CPU/内存/硬盘/网络/TCP等告警规则，所有告警规则以*.yml的后缀存放到/usr/local/prometheus/rules目录下，目录可自定义（详看配置告警规则目录）

- **主机存活**

```
groups:
- name: 主机存活告警  # 命名
  rules:
  - alert: 主机存活告警 # 命名
    expr: up == 0 # 表达式，分析指标判定告警
    for: 60s  # 触发告警持续时间
    labels:   # 自定义告警标签
      severity: warning
    annotations:   # 告警内容注释，根据需要制定
      summary: "{{ $labels.instance }} 宕机超过1分钟！"  
 
```

- **内存利用**

```
groups:
- name: 主机内存使用率告警
  rules:
  - alert: 主机内存使用率告警
    expr: (1 - (node_memory_MemAvailable_bytes / (node_memory_MemTotal_bytes))) * 100 > 80
    for: 15m
    labels:
      severity: warning
    annotations:
      summary: "内存利用率大于80%, 实例: {{ $labels.instance }}，当前值：{{ $value }}%"
```

-  **cpu利用**

```
groups:
- name: 主机CPU使用率告警
  rules:
  - alert: 主机CPU使用率告警
    expr: 100 - (avg by (instance)(irate(node_cpu_seconds_total{mode="idle"}[1m]) )) * 100 > 80
    for: 15m
    labels:
      severity: warning
    annotations:
      summary: "CPU近15分钟使用率大于80%, 实例: {{ $labels.instance }}，当前值：{{ $value }}%"
 
```

- **磁盘利用**

```
# 磁盘利用>80%
groups:
- name: 主机磁盘使用率告警
  rules:
  - alert: 主机磁盘使用率告警
    expr: 100 - node_filesystem_free_bytes{fstype=~"xfs|ext4"} / node_filesystem_size_bytes{fstype=~"xfs|ext4"} * 100 > 80 
    for: 15m
    labels:
      severity: warning
    annotations:
      summary: "磁盘使用率大于80%, 实例: {{ $labels.instance }}，当前值：{{ $value }}%"
```

-  **tcp time_wait**

```
groups:
- name: 主机Tcp TimeWait数量过多告警
  rules:
  - alert: 主机Tcp TimeWait数量过多告警
    expr: node_sockstat_TCP_tw >= 5000
    for: 1m
    labels:
      severity: warning
    annotations:
      summary: "Tcp TimeWait数量大于5000, 实例: {{ $labels.instance }}，当前值：{{ $value }}%"
```

- **iowait**

```
groups:
- name: 主机iowait较高
  rules:
  - alert: 主机iowait较高
    expr: (sum(increase(node_cpu_seconds_total{mode='iowait'}[5m]))by(instance)) / (sum(increase(node_cpu_seconds_total[5m]))by(instance))  *100 >= 10
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "CPU ioWait近5分钟占比大于等于10%, 实例: {{ $labels.instance }}，当前值：{{ $value }}%"
```

-  **磁盘读过大**

```
groups:
- name: 主机磁盘读过大
  rules:
  - alert: 主机磁盘读过大
    expr: sum by (instance) (rate(node_disk_read_bytes_total[2m])) > 50*1024 *1024 
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "磁盘读过大, 实例: {{$labels.instance}}，当前值: {{ $value | humanize1024 }}。"
```

- **磁盘写过大**

```
# 写入 > 50MB/s
groups:
- name: 主机磁盘写过大
  rules:
  - alert: 主机磁盘写过大
    expr: sum by (instance) (rate(node_disk_written_bytes_total[2m])) > 50 * 1024 * 1024
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "磁盘写过大, 实例: {{$labels.instance}}，当前值: {{ $value | humanize1024 }}。"
```

- **重启prometheus生效规则**

```
# 热重载
curl -X POST http://127.0.0.1:9090/-/reload
```





参考文档：

https://blog.csdn.net/manwufeilong/article/details/126159641
