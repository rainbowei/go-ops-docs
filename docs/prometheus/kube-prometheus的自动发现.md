###### 1     kube-prometheus自动发现      

​    如果在我们的 Kubernetes 集群中有了很多的 Service/Pod，那么我们都需要一个一个的去建立一个对应的 ServiceMonitor 对象来进行监控吗？这样岂不是又变得麻烦起来了？

​    为解决上面的问题，Prometheus Operator 为我们提供了一个额外的抓取配置的来解决这个问题，我们可以通过添加额外的配置来进行服务发现进行自动监控。和前面自定义的方式一样，我们想要在 Prometheus Operator 当中去自动发现并监控具有prometheus.io/scrape=true这个 annotations 的 pod，之前我们定义的 Prometheus 的配置如下：

```
- job_name: kubernetes-pods
  honor_timestamps: true
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  tls_config:
    insecure_skip_verify: true
  follow_redirects: true
  relabel_configs:
  - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
    separator: ;
    regex: "true"
    replacement: $1
    action: keep
  - source_labels: [__meta_kubernetes_namespace]
    separator: ;
    regex: (.*)
    target_label: kubernetes_namespace
    replacement: $1
    action: replace
  - source_labels: [__meta_kubernetes_pod_name]
    separator: ;
    regex: (.*)
    target_label: kubernetes_pod
    replacement: $1
    action: replace
  - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
    separator: ;
    regex: (.+)
    target_label: __metrics_path__
    replacement: $1
    action: replace
  - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
    separator: ;
    regex: ([^:]+)(?::\d+)?;(\d+)
    target_label: __address__
    replacement: $1:$2
    action: replace
  - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scheme]
    separator: ;
    regex: (.+)
    target_label: __scheme__
    replacement: $1
    action: replace
  kubernetes_sd_configs:
  - role: pod
    kubeconfig_file: ""
    follow_redirects: true

- job_name: "ack-prd-16-datawarehouse-kafka01"
   metrics_path: '/metrics'
   static_configs:
     - targets:
       - "172.16.3.92:9100"

- job_name: "ack-prd-16-datawarehouse-kafka02"
   metrics_path: '/metrics'
   static_configs:
     - targets:
       - "172.16.3.93:9100"       

- job_name: "ack-prd-16-datawarehouse-kafka03"
   metrics_path: '/metrics'
   static_configs:
     - targets:
       - "172.16.3.91:9100"
    
    
    
```

要想自动发现集群中的 pod，就需要我们在 deployment template 的`annotation`区域添加`prometheus.io/scrape=true`的声明，将上面文件直接保存为 prometheus-additional.yaml，然后通过这个文件创建一个对应的 Secret 对象

```shell
$ kubectl create secret generic additional-configs --from-file=prometheus-additional.yaml -n monitoring
secret "additional-configs" created
```

创建完成后，会将上面配置信息进行 base64 编码后作为 prometheus-additional.yaml 这个 key 对应的值存在：

```shell
$ kubectl get secret additional-configs -n monitoring -o yaml
apiVersion: v1
data:
  prometheus-additional.yaml: LSBqb2JfbmFtZTogJ2t1YmVybmV0ZXMtc2VydmljZS1lbmRwb2ludHMnCiAga3ViZXJuZXRlc19zZF9jb25maWdzOgogIC0gcm9sZTogZW5kcG9pbnRzCiAgcmVsYWJlbF9jb25maWdzOgogIC0gc291cmNlX2xhYmVsczogW19fbWV0YV9rdWJlcm5ldGVzX3NlcnZpY2VfYW5ub3RhdGlvbl9wcm9tZXRoZXVzX2lvX3NjcmFwZV0KICAgIGFjdGlvbjoga2VlcAogICAgcmVnZXg6IHRydWUKICAtIHNvdXJjZV9sYWJlbHM6IFtfX21ldGFfa3ViZXJuZXRlc19zZXJ2aWNlX2Fubm90YXRpb25fcHJvbWV0aGV1c19pb19zY2hlbWVdCiAgICBhY3Rpb246IHJlcGxhY2UKICAgIHRhcmdldF9sYWJlbDogX19zY2hlbWVfXwogICAgcmVnZXg6IChodHRwcz8pCiAgLSBzb3VyY2VfbGFiZWxzOiBbX19tZXRhX2t1YmVybmV0ZXNfc2VydmljZV9hbm5vdGF0aW9uX3Byb21ldGhldXNfaW9fcGF0aF0KICAgIGFjdGlvbjogcmVwbGFjZQogICAgdGFyZ2V0X2xhYmVsOiBfX21ldHJpY3NfcGF0aF9fCiAgICByZWdleDogKC4rKQogIC0gc291cmNlX2xhYmVsczogW19fYWRkcmVzc19fLCBfX21ldGFfa3ViZXJuZXRlc19zZXJ2aWNlX2Fubm90YXRpb25fcHJvbWV0aGV1c19pb19wb3J0XQogICAgYWN0aW9uOiByZXBsYWNlCiAgICB0YXJnZXRfbGFiZWw6IF9fYWRkcmVzc19fCiAgICByZWdleDogKFteOl0rKSg/OjpcZCspPzsoXGQrKQogICAgcmVwbGFjZW1lbnQ6ICQxOiQyCiAgLSBhY3Rpb246IGxhYmVsbWFwCiAgICByZWdleDogX19tZXRhX2t1YmVybmV0ZXNfc2VydmljZV9sYWJlbF8oLispCiAgLSBzb3VyY2VfbGFiZWxzOiBbX19tZXRhX2t1YmVybmV0ZXNfbmFtZXNwYWNlXQogICAgYWN0aW9uOiByZXBsYWNlCiAgICB0YXJnZXRfbGFiZWw6IGt1YmVybmV0ZXNfbmFtZXNwYWNlCiAgLSBzb3VyY2VfbGFiZWxzOiBbX19tZXRhX2t1YmVybmV0ZXNfc2VydmljZV9uYW1lXQogICAgYWN0aW9uOiByZXBsYWNlCiAgICB0YXJnZXRfbGFiZWw6IGt1YmVybmV0ZXNfbmFtZQo=
kind: Secret
metadata:
  creationTimestamp: 2018-12-20T14:50:35Z
  name: additional-configs
  namespace: monitoring
  resourceVersion: "41814998"
  selfLink: /api/v1/namespaces/monitoring/secrets/additional-configs
  uid: 9bbe22c5-0466-11e9-a777-525400db4df7
type: Opaque
```

然后我们只需要在声明 prometheus 的资源对象文件中添加上这个额外的配置：(prometheus-prometheus.yaml)

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  labels:
    prometheus: k8s
  name: k8s
  namespace: monitoring
spec:
  alerting:
    alertmanagers:
    - name: alertmanager-main
      namespace: monitoring
      port: web
  baseImage: quay.io/prometheus/prometheus
  nodeSelector:
    beta.kubernetes.io/os: linux
  replicas: 2
  secrets:
  - etcd-certs
  resources:
    requests:
      memory: 400Mi
  retention: 15d //定义prometheus存储天数    
  ruleSelector:
    matchLabels:
      prometheus: k8s
      role: alert-rules
  securityContext:
    fsGroup: 2000
    runAsNonRoot: true
    runAsUser: 1000
  additionalScrapeConfigs:
    name: additional-configs
    key: prometheus-additional.yaml
  serviceAccountName: prometheus-k8s
  serviceMonitorNamespaceSelector: {}
  serviceMonitorSelector: {}
  storage: #加上下面这一段，一共9句
    volumeClaimTemplate:
      spec:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: 2000M
        storageClassName: eks-online-prometheus
  version: v2.5.0
```

添加完成后，直接更新 prometheus 这个 CRD 资源对象：

```shell
$ kubectl apply -f prometheus-prometheus.yaml
prometheus.monitoring.coreos.com "k8s" configured
```

隔一小会儿，可以前往 Prometheus 的 Dashboard 中查看配置是否生效：

在 Prometheus Dashboard 的配置页面下面我们可以看到已经有了对应的的配置信息了，但是我们切换到 targets 页面下面却并没有发现对应的监控任务，查看 Prometheus 的 Pod 日志：

```shell
$ kubectl logs -f prometheus-k8s-0 prometheus -n monitoring
level=error ts=2018-12-20T15:14:06.772903214Z caller=main.go:240 component=k8s_client_runtime err="github.com/prometheus/prometheus/discovery/kubernetes/kubernetes.go:302: Failed to list *v1.Pod: pods is forbidden: User \"system:serviceaccount:monitoring:prometheus-k8s\" cannot list pods at the cluster scope"
......
```

可以看到有很多错误日志出现，都是`xxx is forbidden`，这说明是 RBAC 权限的问题，通过 prometheus 资源对象的配置可以知道 Prometheus 绑定了一个名为 prometheus-k8s 的 ServiceAccount 对象，而这个对象绑定的是一个名为 prometheus-k8s 的 ClusterRole：（prometheus-clusterRole.yaml）

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus-k8s
rules:
- apiGroups:
  - ""
  resources:
  - nodes/metrics
  verbs:
  - get
- nonResourceURLs:
  - /metrics
  verbs:
  - get
```

上面的权限规则中我们可以看到明显没有对 Service 或者 Pod 的 list 权限，所以报错了，要解决这个问题，我们只需要添加上需要的权限即可：

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus-k8s
rules:
- apiGroups:
  - ""
  resources:
  - nodes
  - services
  - endpoints
  - pods
  - nodes/proxy
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - configmaps
  - nodes/metrics
  verbs:
  - get
- nonResourceURLs:
  - /metrics
  verbs:
  - get
```

更新上面的 ClusterRole 这个资源对象，然后重建下 Prometheus 的所有 Pod，正常就可以看到 targets 页面下面有kubernetes-pods的配置了。然后在我们的deployment里声明如下信息，就可以监控jvm暴漏给我们的监控信息了。

```yaml
annotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "8081"
  
```

