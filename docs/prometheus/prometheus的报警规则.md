###### 1  node相关监控：

- Export down 持续1分钟down了

```
alert:NodeIsDown
expr:up{job="node-exporter"} == 0
for: 1m
labels:
severity: 严重
annotations:
description: {{ $labels.pod }}挂了，持续时间1分钟
```

- node 5分钟内存超过百分之80报警

```
alert:NodeOutOfMemory
expr:100 - node_memory_MemAvailable_bytes{instance!~".+jenkins.+"} / node_memory_MemTotal_bytes * 100 > 80
for: 5m
labels:
severity: 严重
annotations:
description: {{ $labels.instance }} 节点内存已使用80%, 当前值 {{ $value }}
```

- node 5分钟cpu超过百分之80报警

```
alert:NodeHighCpuUsage
expr:100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
for: 5m
labels:
severity: 严重
annotations:
description: {{ $labels.instance }} 节点的 CPU 使用率大于 80%, 当前值 {{ $value }}
```

-  node5分钟磁盘剩余可用空间小于 20%。报警

```
alert:NodeOutOfDiskSpace
expr:node_filesystem_avail_bytes{fstype!="tmpfs"} * 100 / node_filesystem_size_bytes < 18
for: 5m
labels:
severity: 严重
annotations:
description: {{ $labels.instance }} 节点的 {{ $labels.device }} 磁盘剩余可用空间小于 20%，当前值 {{ $value }}
```

##### 2  pod相关监控：

-  pod 2分钟cpu使用率大于 80%。报警

```
alert:K8sPodCpuHigh
expr:sum by(container, pod, namespace, instance) (irate(container_cpu_usage_seconds_total{container!="",container!="",container!="POD",pod!=""}[2m])) / (sum by(container, pod, namespace, instance) (container_spec_cpu_quota{container!="",container!="POD",pod!=""} / 100000)) * 100 > 80
for: 2m
labels:
severity: 严重
annotations:
description: {{ $labels.namespace }}命名空间的 pod: {{ $labels.pod }}cpu使用率大于80，当前值 {{ $value }}
summary: cpu使用率大于80
```

-  pod 2分钟内存使用率大于 80%。报警

```
alert:K8sPodMemoryHigh
expr:sum by(container, pod, namespace, instance) (container_memory_working_set_bytes{container!="",container!="POD",pod!=""}) / sum by(container, pod, namespace, instance) (container_spec_memory_limit_bytes{container!="",container!="POD",pod!=""}) * 100 != +Inf > 80
for: 2m
labels:
severity: 严重
annotations:
description: {{ $labels.namespace }}命名空间的 pod: {{ $labels.pod }}内存使用率大于80，当前值 {{ $value }}
summary: 内存使用率大于80
```





推荐地址：

https://awesome-prometheus-alerts.grep.to/

