# flutter_app_demo

`flutter doctor`: 检查本地 flutter 开发所需的环境

`flutter devices`: 查看连接的设备

`flutter emulators`: 查看已有的模拟器

`flutter emulators --launch <emulator id>`: 运行模拟器

`flutter create projectname`: 创建项目，默认包含所有平台

`flutter create --org com.example --platforms=android,ios projectname`: 创建特定平台的项目，加上 `--empty` 可以创建一个完全干净的项目，没有额外的代码注释和测试用例。

`flutter create --template=package/plugin xxx`：创建一个依赖包或者插件

`flutter run`: 运行项目

`flutter run -d xxx`: 指定某设备运行

`flutter build apk/ipa/web`: 打包 app

`flutter pub get`: 安装依赖包

`flutter pub add/remove xxx`: 添加/移除依赖包

`flutter pub publish`：发布包
