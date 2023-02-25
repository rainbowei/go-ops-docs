###### 1     kube-prometheus架构        

   用自定义的方式来对 Kubernetes 集群进行监控，但是还是有一些缺陷，比如 Prometheus,AlertManager 这些组件服务本身的高可用，当然我们也完全可以用自定义的方式来实现这些需求，我们也知道 Promethues 在代码上就已经对 Kubernetes 有了原生的支持，可以通过服务发现的形式来自动监控集群，因此我们可以使用另外一种更加高级的方式来部署 Prometheus-operator框架..

   operator是由[CoreOS](https://coreos.com/)公司开发的，用来扩展 Kubernetes API，特定的应用程序控制器，它用来创建、配置和管理复杂的有状态应用，如数据库、缓存和监控系统。operator基于 Kubernetes 的资源和控制器概念之上构建，但同时又包含了应用程序特定的一些专业知识，比如创建一个数据库的operator，则必须对创建的数据库的各种运维方式非常了解，创建operator的关键是CRD（自定义资源）的设计。

![promtheus opeator](https://www.qikqiak.com/k8s-book/docs/images/prometheus-operator.png)

------

上图是Prometheus-Operator官方提供的架构图，其中Operator是最核心的部分，作为一个控制器，他会去创建Prometheus、ServiceMonitor、AlertManager以及PrometheusRule4个CRD`资源对象，然后会一直监控并维持这4个资源对象的状态。

其中创建的prometheus这种资源对象就是作为Prometheus Server存在，而ServiceMonitor就是exporter的各种抽象，exporter前面我们已经学习了，是用来提供专门提供metrics数据接口的工具，Prometheus就是通过ServiceMonitor提供的metrics数据接口去 pull 数据的，当然alertmanager这种资源对象就是对应的AlertManager的抽象，而PrometheusRule是用来被Prometheus实例使用的报警规则文件。

这样我们要在集群中监控什么数据，就变成了直接去操作 Kubernetes 集群的资源对象了，是不是方便很多了。上图中的 Service 和 ServiceMonitor 都是 Kubernetes 的资源，一个 ServiceMonitor 可以通过 labelSelector 的方式去匹配一类 Service，Prometheus 也可以通过 labelSelector 去匹配多个ServiceMonitor。

###### 2 kube-prometheus安装

gitlab地址：https://github.com/prometheus-operator/kube-prometheus

下载对应的版本：

```shell
git clone -b release-0.9 --depth=1  https://github.com/prometheus-operator/kube-prometheus.git

cd kube-prometheus/manifests/setup& apply -f .

cd kube-prometheus/manifests/&apply -f . 
```

------

###### 3 -数据持久化

- prometheus持久化： 

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
    retention: 15d     //设置保持15天数据
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

​    部署完成后，会创建一个名为monitoring的 namespace，所以资源对象对将部署在改命名空间下面，此外 Operator 会自动创建4个 CRD 资源对象：

```
$ kubectl get crd |grep coreos
alertmanagers.monitoring.coreos.com     5d
prometheuses.monitoring.coreos.com      5d
prometheusrules.monitoring.coreos.com   5d
servicemonitors.monitoring.coreos.com   5d
```

可以在 monitoring 命名空间下面查看所有的 Pod，其中 alertmanager 和 prometheus 是用 StatefulSet 控制器管理的，其中还有一个比较核心的 prometheus-operator 的 Pod，用来控制其他资源对象和监听对象变化的：

```
$ kubectl get pods -n monitoring
NAME                                  READY     STATUS    RESTARTS   AGE
alertmanager-main-0                   2/2       Running   0          21h
alertmanager-main-1                   2/2       Running   0          21h
alertmanager-main-2                   2/2       Running   0          21h
grafana-df9bfd765-f4dvw               1/1       Running   0          22h
kube-state-metrics-77c9658489-ntj66   4/4       Running   0          20h
node-exporter-4sr7f                   2/2       Running   0          21h
node-exporter-9mh2r                   2/2       Running   0          21h
node-exporter-m2gkp                   2/2       Running   0          21h
prometheus-adapter-dc548cc6-r6lhb     1/1       Running   0          22h
prometheus-k8s-0                      3/3       Running   1          21h
prometheus-k8s-1                      3/3       Running   1          21h
prometheus-operator-bdf79ff67-9dc48   1/1       Running   0          21h
```

查看创建的 Service:

```
kubectl get svc -n monitoring
NAME                    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
alertmanager-main       ClusterIP   10.110.204.224   <none>        9093/TCP            23h
alertmanager-operated   ClusterIP   None             <none>        9093/TCP,6783/TCP   23h
grafana                 ClusterIP   10.98.191.31     <none>        3000/TCP            23h
kube-state-metrics      ClusterIP   None             <none>        8443/TCP,9443/TCP   23h
node-exporter           ClusterIP   None             <none>        9100/TCP            23h
prometheus-adapter      ClusterIP   10.107.201.172   <none>        443/TCP             23h
prometheus-k8s          ClusterIP   10.107.105.53    <none>        9090/TCP            23h
prometheus-operated     ClusterIP   None             <none>        9090/TCP            23h
prometheus-operator     ClusterIP   None             <none>        8080/TCP            23h
```

可以看到上面针对 grafana 和 prometheus 都创建了一个类型为 ClusterIP 的 Service，当然如果我们想要在外网访问这两个服务的话可以通过创建对应的 Ingress 对象或者使用 NodePort 类型的 Service。





参考文档：[搞搞 Prometheus: Alertmanager 解析](https://zhuanlan.zhihu.com/p/63270049?utm_source=wechat_session)

https://blog.csdn.net/qq_37332827/article/details/105114439

https://www.qikqiak.com/k8s-book/docs/58.Prometheus%20Operator.html