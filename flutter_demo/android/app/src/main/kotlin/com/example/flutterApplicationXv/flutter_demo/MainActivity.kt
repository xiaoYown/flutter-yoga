package com.example.flutterApplicationXv.flutter_demo

import android.content.Context
import android.graphics.Color
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.TextView
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

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
    
    // 原生渲染方法
    private fun renderContent(backgroundColor: String, content: String): Boolean {
        Log.d(TAG, "Android: 渲染内容 - 背景颜色: $backgroundColor, 内容: $content")
        
        // 这里可以进行实际的渲染操作，例如创建视图并添加到主窗口
        // 由于此处仅为示例，我们只打印参数并返回成功
        
        // TODO: 第二阶段将在此处调用 SDK 的渲染方法
        
        return true
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
    private val textView: TextView = TextView(context)
    
    init {
        // 设置容器
        containerView.layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        
        // 设置文本视图
        textView.layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        textView.textAlignment = TextView.TEXT_ALIGNMENT_CENTER
        textView.gravity = android.view.Gravity.CENTER
        
        // 添加到容器
        containerView.addView(textView)
        
        // 更新视图内容
        updateViewContent()
    }
    
    private fun updateViewContent() {
        // 设置背景颜色
        try {
            val backgroundColor = creationParams["backgroundColor"] as? String ?: "#FFFFFF"
            containerView.setBackgroundColor(parseColor(backgroundColor))
        } catch (e: Exception) {
            Log.e("NativeView", "背景颜色解析错误", e)
            containerView.setBackgroundColor(Color.WHITE)
        }
        
        // 设置内容
        val content = creationParams["content"] as? String ?: "默认内容"
        textView.text = "Native Render: $content"
        
        Log.d("NativeView", "Android: 视图渲染完成 - viewId: $containerView")
    }
    
    // 安全解析颜色字符串
    private fun parseColor(colorString: String): Int {
        return try {
            Color.parseColor(colorString)
        } catch (e: Exception) {
            Log.w("NativeView", "颜色解析失败: $colorString, 使用默认白色")
            Color.WHITE
        }
    }

    override fun getView(): View {
        return containerView
    }

    override fun dispose() {
        // 清理资源
    }
}
