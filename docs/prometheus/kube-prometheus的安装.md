###### 1  kube-prometheus安装

gitlab地址：https://github.com/prometheus-operator/kube-prometheus

下载对应的版本：

```shell
git clone -b release-0.9 --depth=1  https://github.com/prometheus-operator/kube-prometheus.git

cd kube-prometheus/manifests/setup& apply -f .

cd kube-prometheus/manifests/&apply -f . 
```

###### 2 -数据持久化

-  prometheus持久化： 

  修改文件：kube-prometheus/manifests/prometheus-prometheus.yaml

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
  #-----storage-----
    storage: #这部分为持久化配置
      volumeClaimTemplate:
        spec:
          storageClassName: csi-cephfs
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 100Gi
  #-----------------
    baseImage: quay.azk8s.cn/prometheus/prometheus
    nodeSelector:
      kubernetes.io/os: linux
    podMonitorSelector: {}
    replicas: 2
    resources:
      requests:
        memory: 400Mi
    ruleSelector:
      matchLabels:
        prometheus: k8s
        role: alert-rules
    securityContext:
      fsGroup: 2000
      runAsNonRoot: true
      runAsUser: 1000
    serviceAccountName: prometheus-k8s
    serviceMonitorNamespaceSelector: {}
    serviceMonitorSelector: {}
    version: v2.11.0
  
  ```

  在修改yaml文件之后执行kubectl apply -f /path/to/manifests/prometheus-prometheus.yaml命令，会自动创建两个指定大小的pv卷，因为会为prometheus的备份（prometheus-k8s-0，prometheus-k8s-1）也创建一个pv.

- grafana持久化：

  修改文件：kube-prometheus/manifests/grafana-deployment.yaml

  在grafana-deployment.yaml将emptydir存储方式改为pvc（前提需要创建pvc）方式：

  ```
        #- emptyDir: {}
        #  name: grafana-storage
        - name: grafana-storage
          persistentVolumeClaim:
            claimName: grafana-pvc
        - name: grafana-datasources
          secret:
            secretName: grafana-datasources
        - configMap:
            name: grafana-dashboards
          name: grafana-dashboards
        - configMap:
            name: grafana-dashboard-apiserver
          name: grafana-dashboard-apiserver
        - configMap:
            name: grafana-dashboard-controller-manager
      ........
  
  ```

参考文档：[搞搞 Prometheus: Alertmanager 解析](https://zhuanlan.zhihu.com/p/63270049?utm_source=wechat_session)

https://blog.csdn.net/qq_37332827/article/details/105114439