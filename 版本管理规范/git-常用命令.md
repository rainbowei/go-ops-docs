# Git-常用命令
## 使用前的配置

**检查你的配置**
```bash
# 查看所有的配置以及它们所在的文件
git config --list --show-origin

# 所有 Git 当时能找到的配置
git config --list
```

**全局配置**
配置文件在`git config --list --show-origin` 命令中可查看
```bash
# 对你的 commit 操作设置关联的用户名
git config --global user.name "[name]"

# 对你的 commit 操作设置关联的邮箱地址
git config --global user.email "[email address]"

# 启用有帮助的彩色命令行输出。
git config --global color.ui auto
```

**本地工程配置**
配置文件在当前工程目录/.git/config 文件中
```bash
git config --local user.name xxx
git config --local user.email xxx@xxx.com
```

## 创建仓库
当着手于一个新的仓库时，你只需创建一次。要么在本地创建，然后推送到 GitHub；要么通过 clone 一个现有仓库。
```bash
# 将现有目录转换为一个 Git 仓库
git init

# Clone（下载）一个已存在于 GitHub 上的仓库，包括所有的文件、分支和提交 (commits)
git clone [url]
```

## 进行更改
浏览并检查项目文件的发展。
```bash
# 将文件进行快照处理内容写入暂存区，用于版本控制
git add [file]

# 将暂存区内容添加到仓库中，永久地记录在版本历史中
git commit -m"[descriptive message]"

git commit -am"[descriptive message]" (-am 等同于 -a -m)
## -a参数可以将所有已跟踪文件中的执行修改或删除操作的文件都提交到本地仓库，即使它们没有经过git add添加到暂存区

# 从工作区和索引中删除文件
git rm -rf [file]
```

## 检查历史和状态
```bash
# 查看命令历史
git reflog

# 列出当前分支的版本提交历史
git log

# 用以展示经过修饰的提交历史
git log --graph --decorate --oneline

# 如果只想要看包含关键字“apple”的提交
git log --grep apples --oneline

# 查看历史提交记录中两个点之间的提交历史
git log HEAD~5..HEAD^ --oneline

# 对于分支可以使用该命令
git log branch_name..master --oneline

# 列出文件的版本历史，包括重命名
git log --follow [file]

# 了解谁对一个文件做了哪些改动
git blame path/to/file

# 输出指定 commit 的元数据和内容变化
git show [commit]
```

stash 命令
```bash
# 修改了代码，但不想提交的时候，需要先隐藏再切换分支
git stash (隐藏保存修改的信息)
git stash list (要查看现有的储藏)
git stash apply (获取最新隐藏的信息)
git stash apply stash @{2} (获取更早隐藏的信息)
git stash drop stash @{2} (删除隐藏)
```

检查当前文件状态
```bash
git status
git status -s (状态简览)
```
查看已暂存和未暂存的修改
```bash
# 查看尚未暂存的文件更新了哪些部分
git diff          (工作区 vs 暂存区)
git diff head     (工作区 vs 版本库)
git diff --staged (查看已暂存的将要添加到下次提交里的内容)
git diff --cached (暂存区 vs 版本库)

# 对比两个分支
git diff [first-branch]...[second-branch]
# 对比当前 HEAD 和前两个提交
git diff HEAD HEAD~2
```

## 重做提交
```bash
# 删除前一次提交，并创建一个新的提交记录以替代之前的提交
git commit --amend

# 撤销所有 [commit] 后的的提交，在本地保存更改
git reset [COMMIT_ID]

git reset --soft  (暂存区->工作区)
git reset --mixed (版本库->暂存区)
# 放弃所有历史，改回指定提交。慎重使用
git reset --hard [COMMIT_ID]  (版本库->暂存区->工作区)

# 交互式变基 (rebase）。它可以用来编辑提交信息，或者将多个提交压缩成一个提交
git rebase -i origin/master

# 创建一个新的提交，让当前项目状态恢复到指定提交之前
git revert [COMMIT_ID]
```

## 分支
分支是使用 Git 工作的一个重要部分。你做的任何提交都会发生在当前“checked out”到的分支上。使用 git status 查看那是哪个分支。
```bash
# 列出当前项目分支
git branch

# 创建一个新分支
# 说明：如果报错「fatal: 不是一个有效的对象名：'master'。」说明初始化仓库后还没有任何提交记录。
git branch [branch-name]

# 切换到指定分支并更新工作目录 (working directory)
git checkout [branch-name]

# 将指定分支的历史合并到当前分支。这通常在拉取请求 (PR) 中完成，但也是一个重要的 Git 操作。
git merge [branch]

# 删除指定分支
git branch -d [branch-name]
```

## 同步更改
将你本地仓库与远端仓库同步
```bash
# 下载远端跟踪分支的所有历史
git fetch

# 将远端跟踪分支合并到当前本地分支
git merge


# git push 的一般形式为 git push <远程主机名> <本地分支名> <远程分支名>
# 例如 git push origin master：refs/for/master
# 即是将本地的master分支推送到远程主机origin上的对应master分支， origin 是远程主机名。第一个master是本地分支名，第二个master是远程分支名。

# 将所有本地分支提交上传到 GitHub
git push

# 使用来自 GitHub 的对应远端分支的所有新提交更新你当前的本地工作分支。git pull 是 git fetch 和 git merge 的结合。
git pull

# 假设我们和同事在各自单独的分支上进行开发，同事有一个重要的提交我们也想应用到自己的分支上来，但是不需要对方分支的其他提交
git cherry-pick COMMIT_ID
```
## 多 SSH-Key 生成及代理配置
### 生成一个新的 SSH Key
```bash
# 执行命令生成 ssh-key，需要指定相应的邮箱
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# 推荐不使用默认文件名 id_rsa ，按实际场景重新命名文件名称，比如：/Users/you/.ssh/id_rsa_github_my
> Enter a file in which to save the key (/Users/you/.ssh/id_rsa): [如果不更改文件名直接回车 ]

> Enter passphrase (empty for no passphrase): [输入密码，回车 ]
> Enter same passphrase again: [再次输入密码，回车 ]

# 可以看到刚刚生成的 ssh-key id_rsa_github_my 文件
# 复制对应 id_rsa_github_my.pub 内容添加至 WEB 端配置 SSH 内容地方即可。
$ ll /Users/you/.ssh
```

### 将 SSH Key 添加到不同的代理
```bash
$ vim /Users/you/.ssh/config

# 配置文件参数
# Host : Host 可以看作是一个你要识别的模式，对识别的模式，进行配置对应的的主机名和 ssh 文件（可以直接填写 ip 地址）
# HostName : 要登录主机的主机名（建议与 Host 一致）
# User : 登录名（如 gitlab 的 username）
# IdentityFile : 指明上面 User 对应的 identityFile 路径
# Port: 端口号（如果不是默认 22 号端口则需要指定）

Host github.com
HostName github.com
Preferredauthentications publickey
IdentityFile ~/.ssh/id_rsa_github_my
Port 22

Host dev-git.gaolvzongheng.com
HostName dev-git.gaolvzongheng.com
Preferredauthentications publickey
IdentityFile ~/.ssh/id_rsa_github_gaolvgo
Port 22

Host 119.3.177.8
HostName 119.3.177.8
Preferredauthentications publickey
IdentityFile ~/.ssh/id_rsa_github_gaolvgo
Port 22
```

### 测试配置是否成功
```bash
$ .ssh ssh -T git@github.com
Enter passphrase for key '/Users/liwei/.ssh/id_rsa_github_my':
Hi GourdErwa! You've successfully authenticated, but GitHub does not provide shell access.
```

## 分支管理常用命令
```bash
#origin 就是一个名字，它是在你 clone 一个托管在 Github 上代码库时，git 为你默认创建的指向这个远程代码库的标签.ps : 远程库也可以改叫其他名字 origin 是可以改的
#origin 指向的是 repository(知识库,远程仓库)，master 只是这个 repository 中默认创建的第一个 branch。当你 git push 的时候因为 origin 和 master 都是默认创建的，所以可以这样省略

#关联远程仓库
git remote add origin git@github…….git

#取消本地目录下关联的远程库, 重新关联其他仓库执行上面操作
git remote remove origin

#查看本地分支
git branch

#查看远程分支
git branch -r

#查看本地分支与远程分支
git branch -a

#创建本地分支
git branch branchname
git checkout -b branchname

#有时候删除远程分支会报 git delete remotes: remote refs do not exist 错误信息, 提示远程分支不存在
#原因是我们用 git fetch 保存到本地的缓存信息而已, 只需要先执行一下 git fetch -p origin 命令即可

#删除本地分支
git branch -d branchname

#删除本地暂存分支
git branch -dr origin/branchname

#删除远程分支
git push origin :branchname

#删除远程分支
git push origin --delete branchname

#创建一个分支并关联远程分支的完整流程
# 1. 创建本地分支
git branch branchname

#2. 切换到分支 branchname
git checkout branchname

# 1 和 2 可以合成一步 创建并切换到新分支
git checkout -b branchname

#3. 推送本地分支到远程库
git push origin branchname

#4.建立远程连接,然后就可以 pull 和 push 了
git branch --set-upstream-to origin/branchname

#3 和 4 可以合并成一步 推送本地分支到远程库,分支名一模一样,并同时建立连接
#这种方式更通用
git push -u origin branchname

#git push --set-upstream-to origin/branchname 和 git push -u origin branchname 的区别
- 如果我们本地 dev 分支需要关联远程库 , 第一种方式如果远程没有 dev 分支, 会报错关联不起
- 第二种方式 , 如果没有就会创建一个 dev 的远程分支然后再关联
- 推荐使用第二种,也是比较常用的
```

## 术语表

- HEAD：代表你当前的工作目录。使用 git checkout 可移动 HEAD 指针到不同的分支、标记 (tags) 或提交

- .gitignore 文件：
有时一些文件最好不要用 Git 跟踪。这通常在名为 .gitignore 的特殊文件中完成。你可以在 [github.com/github/gitignore](https://github.com/github/gitignore) 找到有用的 .gitignore 文件模板。


## 参考
- [玩 branch 游戏学git](https://learngitbranching.js.org/?locale=zh_CN)
- [图形化交互式学 git](http://onlywei.github.io/explain-git-with-d3/#commit%E3%80%82)
- [git-book 官方文档](https://git-scm.com/book/zh/v2)
- [gitkraken Git 客户端 ](https://www.gitkraken.com/)
- [Sourcetree Git 客户端 ](https://www.sourcetreeapp.com/)
- [如何使用Git Rebase](https://segmentfault.com/a/1190000019455172)
