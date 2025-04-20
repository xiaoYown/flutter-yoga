package com.example.flutterApplicationXv.flutter_demo

import android.content.Context
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

// Import the SDK (The actual import would be through Gradle/Maven)
// We're adding the SDK class manually for this example
import com.example.yogarendersdk.YogaRenderSDK
// Quick hack to make the compiler aware of the class in the project
// In a real project, this would be properly imported via Gradle
class SdkHelper {
    companion object {
        fun getSdk(): YogaRenderSDK {
            return YogaRenderSDK.getInstance()
        }
    }
}

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.flutterApplicationXv/render"
    private val TAG = "FlutterBridge"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // 设置方法通道
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "renderContent" -> {
                    val backgroundColor = call.argument<String>("backgroundColor")
                    val content = call.argument<String>("content")
                    
                    if (backgroundColor == null || content == null) {
                        result.error("INVALID_ARGUMENTS", "Invalid arguments", null)
                        return@setMethodCallHandler
                    }
                    
                    // 调用渲染方法
                    val success = renderContent(backgroundColor, content)
                    result.success(success)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        
        // 注册原生视图工厂
        flutterEngine.platformViewsController.registry.registerViewFactory(
            "com.example.flutterApplicationXv/nativeView", 
            NativeViewFactory()
        )
    }
    
    // 原生渲染方法 - 现在使用 SDK 实现
    private fun renderContent(backgroundColor: String, content: String): Boolean {
        Log.d(TAG, "Android: 调用 SDK 渲染内容 - 背景颜色: $backgroundColor, 内容: $content")
        
        // 创建临时容器视图用于测试 SDK 渲染功能
        val testContainer = FrameLayout(this)
        
        // 使用 SDK 渲染内容，而不是直接在这里实现渲染逻辑
        return SdkHelper.getSdk().renderContent(testContainer, backgroundColor, content)
    }
}

// 原生视图工厂
class NativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as? Map<String, Any> ?: mapOf()
        return NativeView(context, viewId, creationParams)
    }
}

// 原生视图实现
class NativeView(private val context: Context, id: Int, private val creationParams: Map<String, Any>) : PlatformView {
    private val containerView: FrameLayout = FrameLayout(context)
    
    init {
        // 设置容器
        containerView.layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        
        // 获取渲染参数
        val backgroundColor = creationParams["backgroundColor"] as? String ?: "#FFFFFF"
        val content = creationParams["content"] as? String ?: "默认内容"
        
        // 使用 SDK 渲染内容，而不是直接在这里实现渲染逻辑
        SdkHelper.getSdk().renderContent(containerView, backgroundColor, content)
        
        Log.d("NativeView", "Android: 使用 SDK 视图渲染完成 - viewId: $containerView")
    }

    override fun getView(): View {
        return containerView
    }

    override fun dispose() {
        // 清理资源
    }
}
