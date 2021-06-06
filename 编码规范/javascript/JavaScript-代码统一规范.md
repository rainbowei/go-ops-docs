## 1. Code Style

编码规范请参考 [JavaScript 代码规范(airbnb-javascript)](https://github.com/airbnb/javascript)

## 2. Code Formatter

统一使用 [prettier](https://prettier.io/) 插件进行格式约束。

### VS Code

在应用商店中查找 `Prettier` 插件，并配置 [js-vscode.prettier.settings.json](JavaScript-vscode.prettier.settings.json) 文件内容

### Other [编辑器集成](https://prettier.io/docs/en/editors.html)

**安装**

**使用 yarn**

```
yarn add prettier --dev --exact
# or globally
yarn global add prettier
```

**使用 npm**

```shell script
npm install --save-dev --save-exact prettier
# or globally
npm install --global prettier
```

并在项目根目录[自定义配置文件](https://prettier.io/docs/en/configuration.html) [.prettierrc](.prettierrc)
