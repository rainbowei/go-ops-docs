###### 1 -告警模板

`[root@centos74 home]# cat /usr/local/prometheus/alertmanager/wechat.tmpl
{{ define "wechat.default.message" }}
{{- if gt (len .Alerts.Firing) 0 -}}
{{- range $index, $alert := .Alerts -}}
======== 异常告警 ========
告警名称：{{ $alert.Labels.alertname }}
告警级别：{{ $alert.Labels.severity }}
告警机器：{{ $alert.Labels.instance }} {{ $alert.Labels.device }}
告警详情：{{ $alert.Annotations.summary }}
告警时间：{{ $alert.StartsAt.Format "2006-01-02 15:04:05" }}
========== END ==========
{{- end }}
{{- end }}
{{- if gt (len .Alerts.Resolved) 0 -}}
{{- range $index, $alert := .Alerts -}}
======== 告警恢复 ========
告警名称：{{ $alert.Labels.alertname }}
告警级别：{{ $alert.Labels.severity }}
告警机器：{{ $alert.Labels.instance }}
告警详情：{{ $alert.Annotations.summary }}
告警时间：{{ $alert.StartsAt.Format "2006-01-02 15:04:05" }}
恢复时间：{{ $alert.EndsAt.Format "2006-01-02 15:04:05" }}
========== END ==========
{{- end }}
{{- end }}
{{- end }}`

###### 2 -主要语法

###### 3 -主要语法





参考文档：[搞搞 Prometheus: Alertmanager 解析](https://zhuanlan.zhihu.com/p/63270049?utm_source=wechat_session)