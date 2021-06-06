# Git-版本管理规范
## 一、版本控制规范概述
无特殊说明，项目默认使用 [Git](https://git-scm.com/) 作为版本控制系统，内部平台使用GitLab进行仓库建设，项目分支管理规范采用 [GitFlow](https://datasift.github.io/gitflow/IntroducingGitFlow.html) 模型（具体项目根据实际情况调整）。

## 二、版本号约定
遵循 [语义化版本 2.0.0](https://semver.org/lang/zh-CN/)

## 三、Git Flow 控制流程约定
<img src="https://nvie.com/img/git-model@2x.png" alt="git-flow" style="zoom:60%;" />

### 1.分支命名规范
分支命名
- master
- develop

分支前缀命名
- feature/{YOUR-NAME}-分支名称
- release/{YOUR-NAME}-分支名称
- hotfix/{YOUR-NAME}-分支名称

```shell
# {YOUR-NAME}：为开发者真实姓名全拼小写。
# 分支命名示例
master
develop

feature/liwei-shop
feature/liwei-user

hotfix/v1.0.0

release/v1.0.0
```
### 2. 分支详情
#### master
- 分支说明：线上稳定版本
- 注意事项：
  - 不可直接 push 到远程仓 master 分支
  - 只能被 release 分支或 hotfix 分支合并
#### develop
- 分支说明：当前最新开发成果的分支
- 注意事项：
  - 不可直接 push 到远程仓库 develop 分支
  - 不能与 master 分支直接交互
#### feature
- 分支说明：功能分支，每个功能需分别建立自己的子分支
- 注意事项：
  - 每个 feature 分支颗粒要尽量小，以利于快速迭代和避免冲突
  - 当其中一个 feature 分支完成后，它会合并回 develop 分支
  - 由每组开发管理员负责把所有 feature 分支开发完成的代码合并到 develop 分支
  - feature 分支只与 develop 分支交互，不能与 master 分支直接交互
#### release
- 分支说明：待发布分支，下个版本需上线的版本
- 注意事项：
  - release 分支一旦建立就将独立，不可再从其他分支 pull 代码
  - 必须合并回 develop 分支和 master 分支
  - release 分支测试通过后，合并到 master 分支并且给 master 标记一个版本号
#### hotfix
- 分支说明：紧急修复分支,用来快速给已发布产品修复 bug 或微调功能
- 注意事项：
  - 只能从 master 分支指定 tag 版本衍生出来
  - 一旦完成修复 bug，必须合并回 master 分支和 develop 分支
  - master 被合并后，应该被标记一个新的版本号
  - hotfix 分支一旦建立就将独立，不可再从其他分支 pull 代码

### 3. 工作中遇到的开发场景

#### 新需求
- 创建一个 feature 功能点的分支，如果存在未测试完毕的需求，就基于 master 创建，否则就基于 develop 创建
- 开发完成后将代码合并到 develop 供测试人员测试
- 测试人员在 develop 测试通过后，负责人再将代码发布到 release 供测试人员测试
- 测试人员在 release 测试通过后，负责人再将代码发布到 master 供测试人员测试
- 测试人员在 master 测试通过后，研发人员需要删除 feature/版本号-功能点这个分支

#### 修改预上线环境 Bug
- 在 release 测试出现了 Bug，首先要确认 develop 分支是否同样存在这个问题
- 如果存在，release 分支回滚到前一个版本，修复流程和修复测试环境 Bug 流程一致
- 如果不存在，这种可能性比较少，大部分是数据兼容问题，环境配置问题等

#### 修改正式环境 Bug
- 在 master 测试出现了 Bug，首先把 master 分支回滚到前一个版本保证线上没有问题，
- 确认 release 和 develop 分支是否同样存在这个问题，如果存在，修复流程 与 修复测试环境 Bug 流程一致。
- 如果不存在，这种可能性也比较少，大部分是数据兼容问题，环境配置问题等

#### 紧急修复正式环境 Bug
- 如果 release 分支存在未测试完毕的需求，就基于 master 创建 hotfix 分支，修复完毕后发布到 master 验证，验证完毕后，将 master 代码合并到 release 和 develop 分支，同时删掉 hotfix 分支
- 如果 release 分支不存在未测试完毕的需求，但 develop 分支存在未测试完毕的需求，就基于 release 创建 hotfix 分支，修复完毕后发布到 release 验证，后面流程与上线流程一致，验证完毕后，将 master 代码合并到 develop 分支，同时删掉 hotfix 分支
- 如果 release 和 develop 分支都不存在未测试完毕的需求，流程与修复测试环境 Bug 流程一致

## 四、常用环境
- dev          环境：用于开发者调试使用。
- test         环境：测试稳定环境。
- stage{1..n}  环境：测试临时环境，需要多个特性测试时，启动的多套环境。
- pre          环境：预上线环境。
- prod         环境：生产环境。
---

比如，项目域名为：https://www.gaolvzongheng.com，那么相关环境的域名可这样配置：
- dev         环境：http://www.dev.gaolvzongheng.com
- test        环境：http://www.test.gaolvzongheng.com
- stage{1..n} 环境：http://www.stage1.gaolvzongheng.com
- pre         环境: http://www.pre.gaolvzongheng.com
- prod        环境：https://www.gaolvzongheng.com

| 分支    | 名称         | 环境 | 可访问 |
| :------ | :------------ | :---- | :------ |
| master  | 主分支       | pro  | 是     |
| release | 预上线分支   | pre  | 是     |
| hotfix  | 紧急修复分支 | dev  | 否     |
| develop | 测试分支     | dev  | 是     |
| feature | 需求开发分支 | dev  | 否     |

## 四、Git 提交规范

参考 [git-提交规范.md](版本管理规范/git-提交规范.md)

## 五、工具推荐

- [gitkraken Git 客户端 ](https://www.gitkraken.com/)
- [Sourcetree Git 客户端 ](https://www.sourcetreeapp.com/)
- [A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/)
