# Docker 镜像规范

## 镜像仓库

镜像仓库前缀在 jenkins 中固定为 `swr.cn-north-4.myhuaweicloud.com/glzh-dev`, 只会往 dev 中 push 镜像。

镜像仓库分为两类:

- glzh-library: 存放基础类镜像，比如公司统一的 jdk 镜像。
- glzh-dev: 存放非生产的环境镜像。
- glzh-prod: 存放生产环境镜像。


## 镜像安全

暂未规划


## 镜像精简

暂未规划

## 镜像命名规范

镜像名称默认使用 gitlab 的 `project_name` 来命名镜像，例如: `swr.cn-north-4.myhuaweicloud.com/glzh-dev/gl-lost-center:4.0`

## 镜像版本号

### 测试环境

版本号可以在 Jenkinsfile 中指定，在构建时会生成两个版本号，一个为 `commit short id`，令一个则为 `Jenkinsfile` 中指定的版本号。

> 如果遇到更新代码，版本号未更新的情况，可以使用 commit id 镜像进行版本回退。

### 生产环境

将测试环境测试好的镜像重新 tag 为 `swr.cn-north-4.myhuaweicloud.com/glzh-prod/gl-lost-center:4.0` 并推送到生产环境镜像仓库。

## 镜像清理策略

暂未规划
