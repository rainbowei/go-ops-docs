
## 前言
gitlab 版本：12.8.7-ee

gitlab-master 地址：{gitlab-master}   端口：36622
gitlab-backup 地址：{gitlab-backup}   端口：36622

## backup 同步确认
平时 backup 会同步 master 数据，但是 gitlab 服务处于关闭状态。
如果需要查看 backup 的数据是否和 master 一致，在登录 backup 后执行 `gitlab-ctl start` 并访问 http://{gitlab-backup}
查看完成后请执行 `gitlab-ctl stop`

## 备份恢复

### 备份恢复方法一-gitlab-backup 恢复
登录到 backup 服务器，并执行以下命令：
- 1.1  ls /var/opt/gitlab/backups  查看当前所有备份 (目前备份策略为每天 16：00 备份，备份保留 3 天)
- 1.2  sed -i "s/{gitlab-backup}/dev-git.gaolvzongheng.com\//" /etc/gitlab/gitlab.rb   将访问 url 改成域名 ps: 请将域名绑定的 ip
 修改成 backup 的 ip
- 1.3  gitlab-ctl reconfigure && gitlab-ctl start && gitlab-ctl stop unicorn && gitlab-ctl stop puma && gitlab-ctl
 stop sidekiq  开启 gitlab 服务，并停止 gitlab 产生新数据
- 1.4  gitlab-backup restore BACKUP=1493107454_2018_04_25_10.6.4-ee 恢复数据，恢复过程中需要手动输入 yes 两次
- 1.5  gitlab-ctl restart 开启全部服务
- 1.6  访问网站，查看有无问题

### 备份恢复方法二-挂载数据盘恢复
- 1.1  登录对应华为云账号，进入云硬盘备份，找到最近的 gt-project-gitlab1 的磁盘备份，选择创建磁盘 （备份时间是每天 4：00）
- 1.2  将创建的磁盘挂载在 backup 服务器上 ，ps: 如果 master 服务器是磁盘或者数据库问题，也可以将磁盘挂载在 master 上
- 1.3  gitlab-ctl stop 停止所有服务
- 1.4  umount /var/opt/gitlab 卸载数据盘
- 1.5  mount /dev/vdc1 /var/opt/gitlab 挂载新创建的数据盘
- 1.6  sed -i "s/{gitlab-backup}/dev-git.gaolvzongheng.com\//" /etc/gitlab/gitlab.rb   将访问 url 改成域名，ps: 请将域名绑定的 ip
 修改成 backup 的 ip
- 1.7  gitlab-ctl reconfigure && gitlab-ctl start 开启服务
- 1.8  blkid /dev/vdc1 得到新磁盘的 uuid
- 1.9  vim /etc/fastab && mount -a 将新磁盘设置开机挂载，并测试，ps: 该配置文件有问题，会导致开机失败

### 备份方法三（不需手动操作）
gitlab-master 上运行着 lsyncd，该程序用于监视/etc/gitlab 和/var/opt/gitlab 两个目录，如果检测到有改动，则自动 copy 到 backup 服务器
ps: 如果有误删除的操作，该操作也会同步到 backup 服务器！

