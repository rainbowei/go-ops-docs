# Kubernetes 部署规范

## 日志规范

日志目前先输出到 docker 的 json-log 日志中，可以打两个输出设备 `/dev/stderr` 和 `/dev/stdout` 中，目前日志还未设计好 es 集群, 暂定使用。


## 监控


## Yaml 规范


### Deployment

- label
- annocation 
- spec
- template


### Service

- label
- dnsConfig
- session

## Istio

### 域名

开发环境: *.dev.gaolvzongheng.com

### VirtualService

### DestnationRule

### GateWay

