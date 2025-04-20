# YogaCardKit

## 目标
- 开发一个 swift package, 使用 SPM 管理, 包名 YogaCardKit. (以后会发不到 SPM, 目前暂不发布)
- 核心模块 "卡片渲染引擎": YogaCardRender
- 核心模块 "渲染引擎 SDK": YogaCardSDK

## 需求
- 设计一组 json schema, 符合 Yoga 3.2 的布局配置, 并且包含其他渲染样式属性
- 设计一套 button/text/image/box 的组件
- "卡片渲染引擎" 可以更具接收到的 json schema, 渲染对应的组件及其样式, 完成卡片的渲染
- "渲染引擎 SDK" 接收到 json schema, 使用 "卡片渲染引擎" 渲染卡片
- 应用: IOS 应用引入 "渲染引擎 SDK", 提供卡片渲染容器以及 json 数据, 将卡片渲染到提供的容器内
- "卡片渲染引擎", "渲染引擎 SDK" 的说明文档
- YogaCardKit 的渲染应该脱离 Swift UI，避免引用项目的差异出现问题

## 目录结构
```sh
YogaCardKit/
├── Package.swift         # 包描述文件（类似 package.json）
├── Sources/              # 主代码目录
│   └── YogaCardKit/        # 模块名（和包名一致）
│       └── YogaCardKit.swift
├── Tests/                # 测试代码目录
│   ├── YogaCardKitTests/   # 测试模块（命名规范：<模块名>Tests）
│   │   ├── YogaCardKitTests.swift
│   │   └── XCTestManifests.swift
│   └── LinuxMain.swift   # Linux 测试入口（Swift 5.4+ 可省略）
└── README.md
```

## 相关资料
Yoga 文档: https://www.yogalayout.dev/

## 注意事项
- Yoga 3.2 已经不再发布到 CocoasPods
- Yoga 3.2 已经不再支持 YogaKit
- Yoga 3.2 已经不再编写 IOS 代码, 但是提供了 cpp 支持 IOS 
- 一定要使用 Yoga 进行作做布局渲染

---

# YogaCardKit 测试应用

## 应用目录
./YogaCardDemo

## 引入 YogaCardKit 方式
- 给 YogaCardDemo 添加 package 管理文件 Package.swift
- 编写一个 switch-import.sh 脚本, 通过不容的参数切换本地和生产引用, 具体切换命令如下:
```sh
# 切换为本地引用
swift package edit YogaCardKit --path ../YogaCardKit
# 切换为生产引用
swift package unedit YogaCardKit
```

## 任务
- 按照 YogaCardKit 的文档, 调用 YogaCardSDK 测试包的 UI 渲染
- 给 YogaCardSDK 提供卡片渲染容器和 json 数据
- 提供一个 schema json 文件进行测试, 直接使用该 json 调用 YogaCardSDK 渲染卡片

