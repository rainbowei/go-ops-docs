> #### 作者：孙科伟
此文档主要用来介绍怎么通过Jenkins来部署本项目到kubernets环境中。

## 1. Jenkins插件要求：
所需插件：kubernetes-cli 。目前测试过的版本号为：kubernetes-cli 1.10.0
Jenkins版本：Jenkins 2.260

## 2. jenkins主从配置：
master我们通过docker-compose方式安装:
```
version: '3'
services:
  jenkins-master:
    image: jenkins/jenkins:lts-jdk11
    user: root
    restart: always
    environment:
      TZ: "Asia/Shanghai"
      JENKINS_UC: "https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/"
      JENKINS_UC_DOWNLOAD: "https://mirrors.tuna.tsinghua.edu.cn/jenkins/"
      JAVA_OPTS: "-Xms512m -Xmx512m"
    ports:
    - "8080:8080"
    - "50000:50000"
    volumes:
    - /data/jenkins/jenkins_home:/var/jenkins_home
    - /var/run/docker.sock:/var/run/docker.sock
    - /usr/bin/docker:/usr/bin/docker
    - /usr/bin/docker-compose:/usr/bin/docker-compose
   extra_hosts:
    - "dev-git.gaolvzongheng.com:10.20.9.156"
```
## 3. jenkins从节点配置：
点击系统管理-->节点管理-->新建节点,输入节点名称，选择固定节点新建从节点。
![avatar](../images/jenkins.png),这里指定安装目录和启动方式。然后点击保存。
![avatar](../images/agent.png)
根据提升下载agent的jar包，然后在从节点主机上，根据提提示的命令启动从节点。
## 3. 新建piplile项目：
Jenkinsfile文件内容如下：
```
def huawei_hub="swr.cn-north-4.myhuaweicloud.com"
node{
    
    stage('初始化') {
        echo "1.Prepare Stage"
        checkout scm
        script {
            build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
        }
    }
 
    stage('构建镜像') {
     withCredentials([usernamePassword(credentialsId: 'huaweihub', passwordVariable: 'huaweiHubPassword', usernameVariable: 'huaweiHubUser')]) {
        sh "docker login -u ${huaweiHubUser} -p ${huaweiHubPassword} ${huawei_hub}"}
        sh "docker build -t swr.cn-north-4.myhuaweicloud.com/glzh-ops/flush-huawei-cdn:${build_tag} ."
    }
    stage('推送镜像') {
        echo "4.Push Docker Image Stage"

            sh "docker push  swr.cn-north-4.myhuaweicloud.com/glzh-ops/flush-huawei-cdn:${build_tag}"
        }
    stage('发布应用') {
        echo "5. Deploy Stage"
        sh "sed -i 's/<BUILD_TAG>/${build_tag}/' k8s-deploy.yaml"
     withKubeConfig([credentialsId: 'dev-k8s-auth', serverUrl: 'https://10.20.0.126:5443']) {

        sh 'kubectl apply -f k8s-deploy.yaml -n ops --record'
        }
    }
}

```

主要是最后一步，发布阶段，安装完kubernetes-cli插件后将支持withKubeConfig字段，然后就可以通过kubectl命令直接发布。其中serverURL
指定的是kubernets api 服务监听的地址。credentialsId 则是我们通过在kubernets master端通过kubectl创建serveracout账号指定的密钥。
具体命令如下所示：
1. 创建serviceaccount
```
kubectl -n devops create serviceaccount jenkins-robot
```
2 .角色绑定
```
kubectl -n devops create rolebinding jenkins-robot-binding --clusterrole=cluster-admin --serviceaccount=devops:jenkins-robot
```
3 .获取 ServiceAccount
```
kubectl -n devops get serviceaccount jenkins-robot -o go-template --template='{{range .secrets}}{{.name}}{{"\n"}}{{end}}
输出结果：
jenkins-robot-token-n8w6b
```
4 .基于base64解码 ServiceToken
```
eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZXZvcHMiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoiamVua2lucy1yb2JvdC10b2tlbi1uOHc2YiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJqZW5raW5zLXJvYm90Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiOTcyZTY0OGYtMTYxZC00NmM5LWI0ZjgtYjFkNTdlOWY4NTBjIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmRldm9wczpqZW5raW5zLXJvYm90In0.ArQvcaEqCaeU1ZcJ6nOC5rLaTZr_vLDrpLCt87asltMUWj2gSli_mXUTrl09hBnBDXI3A1D4rJXHKLHjIAA4nN8qRIRGbpqSNzDwmqJr-jmmmWWZFrZ3n3Al9-13KJnNOK8pcWr70rt3Rsigt4B6CIQ0-ZLK8BZhvROJSifeOfJ6xe2KBqdXBv1ccZZZfEhPLgGbaR5yWm5jLvOMr2MQiPDrZoHOEkcMt-C0xipytOp4sJCJ4bQhb-UoMu1owYydxbd6O7xO71fvqP_bMDpZXC601nA2ggK7h-vi6CJffHv5MM59q8X_DWe1NnZS6KXiMmkXqAmBn10Yu20PNj-kjg
```
5 .添加  Secret text 验证信息
![avatar](../images/secret.png)
这里的secert子段输入，我们第四步获取到的service token值。
id值则为我们创建pipeline时候```withKubeConfig([credentialsId: 'dev-k8s-auth', serverUrl: 'https://10.20.0.126:5443']) ```指定的credentialsId值。





