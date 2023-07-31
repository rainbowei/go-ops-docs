###### 1  配置pushgateway：

- pushgateway的deployment文件内容


```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: monitoring
  name:  pushgateway
  labels:
    app:  pushgateway
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8080"
spec:
  replicas: 1
  revisionHistoryLimit: 0
  selector:
    matchLabels:
      app:  pushgateway
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: "25%"
      maxUnavailable: "25%"
  template:
    metadata:
      name:  pushgateway
      labels:
        app:  pushgateway
    spec:
      containers:
        - name:  pushgateway
          image: 272103279009.dkr.ecr.ap-northeast-1.amazonaws.com/pushgateway:v1.5.1
          imagePullPolicy: IfNotPresent
          livenessProbe:
            initialDelaySeconds: 600
            periodSeconds: 10
            successThreshold: 1
            failureThreshold: 10
            httpGet:
              path: /
              port: 9091
          ports:
            - name: "app-port"
              containerPort: 9091
          resources:
            limits:
              memory: "1000Mi"
              cpu: 1
            requests:
              memory: "1000Mi"
              cpu: 1
```

- pushgateway的service文件内容：

```cobol
apiVersion: v1
kind: Service
metadata:
  name: pushgateway
  namespace: monitoring
  labels:
    app: pushgateway
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9091"
spec:
  selector:
    app: pushgateway
  #type: NodePort
  ports:
    - name: pushgateway
      port: 9091
      targetPort: 9091
```

###### 2  推送指定的数据格式到pushgateway：

现在普罗米修斯还采集不到任何和pushgateway相关的数据，因为我们需要将数据上报到pushgateway，普罗米修斯才可以采集到，所以现在需要将数据推送到pushgateway。

```
metric指标名 3.6指标值   pushgateway这个是job的名字  这些都是固定的格式
 
echo "metric 3.6" | curl --data-binary @- http://pushgateway:9091/metrics/job/pushgateway
 
注：--data-binary 表示发送二进制数据，注意：它是使用POST方式发送的！
```

从prometheus查找

![image-12](/Users/sunkewei/Desktop/go-ops-docs/docs/images/image-12.png)

##### 3  添加复杂数据：

```
cat <<EOF | curl --data-binary @- http://push-prometheus.ttt.mucang.cn/metrics/job/pushgateway/instance/test_instance
#TYPE node_memory_usage gauge
node_memory_usage 36
# TYPE memory_total gauge
node_memory_total 36000
EOF
```

![](/Users/sunkewei/Desktop/go-ops-docs/docs/images/image-13.png)

![](/Users/sunkewei/Desktop/go-ops-docs/docs/images/image-14.png)

#####  4 删除某个组下某个实例的所有数据：

```
curl -X DELETE http://push-prometheus.ttt.mucang.cn/metrics/job/test_job/instance/test_instance
 
删除某个组下的所有数据：
curl -X DELETE http://192.168.124.26:9091/metrics/job/test_job
```

##### 5 把数据上报到pushgateway

在被监控服务所在的机器配置数据上报,这个脚本是采集内存信息的

```shell
[root@node1 ~]# cat push.sh 
node_memory_usages=$(free -m | grep Mem | awk '{print $3/$2*100}')
job_name="memory"
instance_name="192.168.100.6"
 
cat <<EOF | curl --data-binary @- http://push-prometheus.ttt.mucang.cn/metrics/job/$job_name/instance/$instance_name
#TYPE node_memory_usages gauge
node_memory_usages $node_memory_usages
EOF
```

打开pushgateway web ui界面，可看到如下： 

![](/Users/sunkewei/Desktop/go-ops-docs/docs/images/image-16.png)

打开prometheus ui界面，可看到如下memory_usage的metrics指标

![](/Users/sunkewei/Desktop/go-ops-docs/docs/images/image-17.png)

设置计划任务，每分钟定时上报数据

```shell
crontab -e
*/1 * * * * /root/push.sh

注意：从上面配置可以看到，我们上传到pushgateway中的数据有job, 也有instance。而prometheus配置pushgateway这个job_name中也有job和instance，这个job和instance是指pushgateway实例本身，所以job任务yaml中添加 honor_labels: true 参数， 可以避免promethues的targets列表中的job_name是pushgateway的 job 、instance 和上报到pushgateway数据的job和instance冲突。

```

![image-18](/Users/sunkewei/Desktop/go-ops-docs/docs/images/image-18.png)







参考文档：[安装pushgateway](https://www.yoyoask.com/?p=8757)
