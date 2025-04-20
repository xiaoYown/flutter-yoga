## yoga 适配 IOS/Android SDK 封装

### IOS/Android 原生包封装

1. IOS/Android 调用 SDK
2. 调用方法渲染容器, 提供容器基础属性宽高
3. 调用方法渲染内容, 传入 json schema, 使用 yoga v3.2 引擎渲染内容(shcema 格式符合 yoga 引擎渲染)
4. 包可分别发布到 IOS/Android 包管理平台
5. 分别编写两个平台的 SDK 调用方法说明文档

### 编写包测试案例

1. 创建 flutter 项目测试 IOS/Android 包的运行情况
2. 分别在 flutter 项目的 ios/android 原生代码中引入编写的包
3. 在 flutter 项目的 ios/android 中编写 flutter 桥接方法，提供给测试项目 flutter 项目调用。桥接方法不做任何逻辑处理，仅将接受到的参数完全传递给 SDK
4. flutter 测试项目调用桥接方法，渲染内容

项目整体运行流程:

Flutter 测试应用 → Flutter 桥接层(MethodChannel) → 原生应用接收调用 → 原生应用调用原生适配层 SDK → SDK 层使用 Yoga 引擎渲染

### 注意事项

1. Yoga 3.2 已经不再发布到 CocoasPods
2. Yoga 3.2 已经不再支持 YogaKit
3. Yoga 3.2 已经不再编写 IOS 代码, 但是提供了 cpp 支持 IOS 接入
4. 原生应用层和任何原生代码中不要有 flutter 的代码，原生应用层和任何原生代码中不要有 flutter 的代码，原生应用层和任何原生代码中不要有 flutter 的代码
5. flutter 应用中不该有任何 yoga 代码，flutter 应用中不该有任何 yoga 代码，flutter 应用中不该有任何 yoga 代码
