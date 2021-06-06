#                       **iOS 团队代码规范**
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
## 前言
由于是多人协同开发, 为了便于后期项目的扩展维护及 CodeReview, 除了好的设计框架外, 良好的编码习惯也极为重要, 能大量减少开发人员的时间成本. 在我看来, 好的代码首先要保证代码逻辑清晰, 然后再考虑简洁、 扩展、 重用等问题. 逻辑清晰的代码几乎不需要注释来说明, 但鉴于每个人的编程习惯不同, 为了加速团队成员间的协同开发, 建议在自我觉得定义模糊或命名不清晰处还是做好标注工作. 请使用 #pragma #warning #TODO // 等来做好注释说明.

* 编码规范参考 [苹果官方规范文档 ](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html#//apple_ref/doc/uid/10000146-SW1)
* 可以借鉴该篇博客: [翻译自官方文档 ](https://www.jianshu.com/p/e399e023d049)

## 常量
 在常量的使用上,尽量使用类型常量,而不是使用宏定义.比如: 要定义一个字符串常量,可以写成:
`static NSString * const STMProjectName = @"GCDFetchFeed"`

## 变量
对于变量来说,我认为好的编码习惯是:
1. 变量名应该明确体现出功能,最好再加上类型做后缀.
这样也就明确了每个变量都是做什么的,而不是把一个变量当作不同的值用在不同的地方.
2. 在使用之前,需要先对变量做初始化,并且初始化的地方离使用它的地方越近越好.
3. 不要滥用全局变量, 尽量少用它来传递值,通过参数传值可以减少功能模块间的耦合.
比如: 下面这段代码中,当名字为字符串时,就可以把字符串类型作为后缀加到变量名后面.
```
let nameString = "Tom"
print("\(nameString)")
nameLabel.text = nameString
```

## 属性
在 iOS 开发中,关于属性的编码规范,需要针对开发语言作区分:
* Objective-C 里的属性,要尽量通过 get 方法来进行懒加载,以避免无用的内存占用和多余的计算.
* Swift 的计算属性如果是只读,可以省掉 get 子句.示例代码如下:
```
var rectangleArea: Double {
	return long * wide
}
```

## 条件语句
在条件语句中, 需要考虑到条件语句中可能涉及的所有分支条件, 对于每个分支都要考虑到, 并进行处理, 减少或不适用默认处理. 特别是使用 Switch 处理枚举时, 不要有 default 分支.
在 iOS 开发中, 你使用 Swift 语言编写 Switch 语句时, 如果不加 default 分支的话, 当枚举有新增值时, 编译器会提醒你增加分支处理. 这样, 就可以有效避免分支漏处理的情况.
另外, 条件语句的嵌套分支不宜过多, 可以充分利用 Swift 中的 guard 语法. 比如, 这一段处理登录的示例代码:
```
if let userName = login.userNameOK {
	if let password = login.passwordOK {
		// 登录处理
		...
    } else {
    	fatalError("login error")
	}
} else {
	fatalError("login error")
}
```
上面这段代码表示的是, 当用户名和密码都没有问题时再进行登录处理. 那么, 我们使用 guard 语法时, 可以改写如下:
```
guard
	let userName = login.userNameOK,
	let password = login.passwordOK,
	else {
		fatalError("login error")
}
// 登录处理
...
```

可以看到, 改写后的代码更易读了, 异常处理都在一个区域, guard 语句真正起到了守卫的职责.而且你一旦生命了 guard, 编译器就会强制你去处理异常, 否则就会报错. 异常处理越完善, 代码就会越健壮. 所以, 条件语句的嵌套处理, 你可以考虑使用 guard 语法.

## 循环语句
在循环语句中, 我们应该尽少地使用 continue 和 break, 同样可以使用 guard 语法来解决这个问题.解决方法是: 所有需要 continue 和 break 的地方统一使用 guard 去处理, 将所有异常都放到一处. 这样做的好处是, 在维护的时候方便逻辑阅读, 使得代码更加易读和易于理解.

## 函数
对于函数来说, 体积不宜过大, 最好控制在百行代码以内. 如果函数内部逻辑多, 我们可以将复杂逻辑分解成多个小逻辑, 并将每个小逻辑提取出来作为一个单独的函数. 每个函数处理最小单位的逻辑, 然后一层一层往上组合.
这样, 我们就可以通过函数名明确那段逻辑处理的目的,提高代码的可读性.
拆分成多个逻辑简单的函数后, 我们需要注意的是, 要对函数的入参进行验证.
另外, 函数内尽量避免使用全局变量来传递数据, 使用参数或者局部变量传递数据能够减少函数对外部的依赖,减少耦合,提高函数的独立性,提高单元测试的准确性.

## 类
在 Objective-C 中, 类的头文件应该尽可能少地引入其他类的头文件. 你可以通过 class 关键字来声明, 然后在实现文件里引入需要的其他类的头文件.
对于继承和遵循协议的情况, 无法避免引入其他类的头文件, 所以你在代码设计时还是要尽量减少继承,特别是继承关系太多时不利于代码的维护和修改, 比如说修改父类时还需要考虑对所有子类的影响, 如果评估不全, 影响就难以控制.

## 分类
在写分类时, 分类里增加的方法名要尽量加上前缀, 而如果是系统自带类的分类的话, 方法名就一定要加上前缀, 来避免方法名重复的问题.
分类的作用如其名, 就是对类做分类用的, 所以建议把一个类里的公共方法放到不同的分类里, 便于管理维护. 分类特别适合多人负责同一个类时, 根据不同分类来进行各自不同功能的代码维护.

## Code Review
还可以参考其他公司对 iOS 开发制定的编码规范,比如 [Spotify](https://github.com/spotify/ios-style) 的 Objective-C 编码规范、 [纽约时报 ](https://github.com/NYTimes/objective-c-style-guide) 的 Objective-C 的编码规范、 [Raywenderlich](https://github.com/raywenderlich/objective-c-style-guide) 的 OC 编码规范、 [Raywenderlich](https://github.com/raywenderlich/swift-style-guide) 的 Swift 编码规范.

* 后续待团队成员补充及修正
