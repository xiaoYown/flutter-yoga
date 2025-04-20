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

---

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

---

# 第 3 阶段：渲染内容 SDK 进一步封装

## 目标
SDK 渲染内容使用 Yoga 3.2 完成

## 相关资料
Yoga 文档: https://www.yogalayout.dev/

## 子任务
- 设计一组 json schema 的规则，完全符合 Yoga 3.2 的渲染机制，SDK 接收设计 schema json 进行渲染(请查询 Yoga 官网最新使用文档)
- 设计一套 button/text/image/container 的组件，根据接收到的 schema json 进行基于 Yoga 进行布局和渲染
- SDK 接入 Yoga 3.2（IOS 通过 C++ 编译入项目， Android 按照官方 kotlin 即可）, SDK 使用 Yoga 进行渲染
- SDK 调用方式修改后，参数发生变动，同步给 flutter 和 flutter 原生应用层 的调用处(IOS/Android 原生层参数传递， flutter 参数传递)

## 渲染内容执行流程
Flutter 示例项目 dart 调用原生层桥接方法，提供渲染内容的最外层容器以及 schema json -> 原生层直接调用 SDK 渲染方法，提供渲染容器以及透传 schema json 给 SDK -> SDK 根据 schema json 使用 Yoga 进行布局，完成各类节点的渲染


## 可交付物
- 示例调用 
- SDK 使用文档文档

## 注意事项
- Yoga 3.2 已经不再发布到 CocoasPods
- Yoga 3.2 已经不再支持 YogaKit
- Yoga 3.2 已经不再编写 IOS 代码, 但是提供了 cpp 支持 IOS 接入
- SDK层任何原生代码中不要有 flutter 的代码，只负责使用 yoga 渲染内容
- yoga 支持的 ios 基础版本是 13.4