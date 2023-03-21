###### 1  prometheus标签管理：

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

