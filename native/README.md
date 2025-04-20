# 渲染内容 SDK

本目录包含从 Flutter 应用中抽离出来的原生渲染 SDK。

## 目录结构

- `ios_sdk/`: iOS 平台的渲染 SDK
- `android_sdk/`: Android 平台的渲染 SDK

## iOS SDK

iOS SDK 提供了通过 `YogaRenderSDK` 类来渲染内容的功能：

```swift
// 获取 SDK 单例
let sdk = YogaRenderSDK.shared

// 渲染内容到已有视图
let success = sdk.renderContent(in: containerView, backgroundColor: "#3388FF", content: "渲染内容")

// 创建带有渲染内容的新视图
let contentView = sdk.createContentView(frame: CGRect(...), backgroundColor: "#3388FF", content: "渲染内容")
```

### 集成方式

iOS SDK 可以通过 CocoaPods 或 Swift Package Manager 集成：

```ruby
# Podfile
pod 'YogaRenderSDK', :path => '../native/ios_sdk'
```

## Android SDK

Android SDK 提供了通过 `YogaRenderSDK` 类来渲染内容的功能：

```kotlin
// 获取 SDK 单例
val sdk = YogaRenderSDK.getInstance()

// 渲染内容到已有容器
val success = sdk.renderContent(containerView, "#3388FF", "渲染内容")

// 创建带有渲染内容的新视图
val contentView = sdk.createContentView(context, "#3388FF", "渲染内容")
```

### 集成方式

Android SDK 可以通过 Gradle 集成：

```groovy
// settings.gradle
include ':yogarendersdk'
project(':yogarendersdk').projectDir = new File('../native/android_sdk')

// app/build.gradle
dependencies {
    implementation project(':yogarendersdk')
}
```

## 使用说明

1. SDK 负责所有内容的渲染，Flutter 和应用层不做内容渲染
2. 渲染参数由 Flutter 或应用层提供，但具体的渲染实现由 SDK 完成
3. SDK 可以独立于 Flutter 使用，也可以在 Flutter 项目中通过平台通道调用 