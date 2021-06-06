# ELK 日志规范

## 收集规范

### JAVA

目前的 java 的 log4j.xml 规范为 

```
<PatternLayout pattern="%d{yyyy-MM-dd HH:mm:ss.SSS} [%-4p] (%-30F:%L)---%m%n"/>
```

对 java 日志的处理, 只解析了 time 字段和日志级别字段

```
%{TIMESTAMP_ISO8601:time} \\[%{LOGLEVEL:log_level}] %{JAVALOGMESSAGE}"
```

java 日志输出目录，支持 `console` 控制台和 `/app/logs/xx.log` 文件两种格式的搜集


### NodeJs

目前没有 nodejs server 模式运行，默认搜集 nginx 日志，没有做过滤和匹配处理


### Istio Ingress

目前只有搜集并未分词


### Nginx 

目前未搜集



## ES 索引规范


### 业务日志

#### 后台
1. 控制台日志，控制台日志目前使用索引 app-console 
2. 日志文件, 日志文件目前使用索引 app-file

### 前端

使用容器标准输出直接在 app-console 中查询

### 集群容器标准输出

使用 app-console 索引

### Istio Ingress

使用 ingressgateway-access 索引

### nginx 索引

暂定

## Kibana 使用说明

待更新
