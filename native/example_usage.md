# SDK 使用示例

本文档展示如何在原生应用中直接使用 SDK，不依赖 Flutter。

## iOS 示例

```swift
import UIKit
import YogaRenderSDK

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建渲染容器
        let containerView = UIView(frame: CGRect(x: 50, y: 100, width: 300, height: 200))
        view.addSubview(containerView)
        
        // 使用 SDK 渲染内容
        YogaRenderSDK.shared.renderContent(
            in: containerView,
            backgroundColor: "#3388FF",
            content: "通过 SDK 直接渲染的内容"
        )
        
        // 或者直接创建带有内容的视图
        let contentView = YogaRenderSDK.shared.createContentView(
            frame: CGRect(x: 50, y: 350, width: 300, height: 200),
            backgroundColor: "#FF5533",
            content: "另一个渲染示例"
        )
        view.addSubview(contentView)
    }
}
```

## Android 示例

```kotlin
import android.os.Bundle
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import com.example.yogarendersdk.YogaRenderSDK

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        // 获取 SDK 实例
        val sdk = YogaRenderSDK.getInstance()
        
        // 创建渲染容器
        val container = findViewById<FrameLayout>(R.id.container)
        
        // 使用 SDK 渲染内容
        sdk.renderContent(
            container,
            "#3388FF",
            "通过 SDK 直接渲染的内容"
        )
        
        // 或者直接创建带有内容的视图
        val contentView = sdk.createContentView(
            this,
            "#FF5533",
            "另一个渲染示例"
        )
        
        // 添加到布局
        val secondContainer = findViewById<FrameLayout>(R.id.second_container)
        secondContainer.addView(contentView)
    }
}
```

## 从 Flutter 调用 SDK 的区别

当从 Flutter 调用 SDK 时，需要通过 MethodChannel 和 PlatformView 桥接，而在原生应用中可以直接调用 SDK API。

### Flutter 调用方式（回顾）

1. Flutter 层创建平台视图容器
2. 通过平台通道传递参数
3. 原生层接收参数并调用 SDK
4. SDK 在原生容器中渲染内容

### 原生调用方式（本文示例）

1. 直接在原生代码中创建容器
2. 直接调用 SDK API
3. SDK 在容器中渲染内容

两种方式的主要区别在于中间的桥接层，但 SDK 的核心功能保持一致，实现了渲染逻辑的解耦与复用。 