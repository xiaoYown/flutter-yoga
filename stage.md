# 第 1 阶段：Flutter 项目搭建 

## 目标
搭建一个 Flutter 测试项目（flutter_demo）, IOS 标志: com.example.flutterApplicationXv

## 子任务
- 配置代理 export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890 后， 创建 Flutter 工程 
- 在 `ios/` 和 `android/` 子目录中，统一创建同命名桥接方法，提供给 flutter 调用 
- UI 渲染: flutter 层提供基础渲染容器，调用原生层桥接方法，传递内容渲染参数(background, content)，在原生层做渲染，flutter 不做内容渲染
- 原生层提供的桥接方法功能: 由 flutter 层提供渲染容器调用原生层桥接方法传递渲染参数内容进行渲染 

## 完成情况
1. 已创建 Flutter 工程 `flutter_demo`
2. 实现了 Flutter 端的平台桥接类 `PlatformBridge`
3. 在 iOS 端通过 AppDelegate.swift 中实现了对应的桥接方法
4. 在 Android 端通过 MainActivity.kt 中实现了对应的桥接方法
5. 创建了示例 UI 界面用于测试桥接功能

## 后续改进
1. 后续可考虑将原生代码抽取为独立的 SDK 模块
2. 使用 Melos 管理多包结构，实现更清晰的项目组织
3. 完善错误处理机制，增强桥接通信的稳定性

# 第 2 阶段：渲染内容 SDK 拆分

## 目标
抽离原生层 UI 渲染方法封装为 SDK， SDK 根据接受到的参数渲染内容。

## 子任务
- 将接收渲染内容的方法抽离成 SDK，Flutter 和应用层不做内容的渲染， 内容渲染完全在 SDK 内部完成，原生应用层仅负责调用 SDK 传递参数
- SDK 接收渲染内容的参数，根据参数渲染内容到原生层提供的容器内
- SDK 统一放置在 flutter_demo 的同级目录 native 下，分别创建 IOS/Android 的 SDK 目录
- flutter 项目原生层引用刚才创建好的 IOS/Android SDK 进行渲染

## 注意事项
- 一定要记住，flutter 和应用层不做任何内容的渲染，内容的渲染交给 SDK 处理
- 封装好 SDK 后，引用时请注意引用路径