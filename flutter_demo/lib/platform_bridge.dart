import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 平台桥接类，用于与原生层通信
class PlatformBridge {
  /// 方法通道名称
  static const MethodChannel _channel = MethodChannel('com.example.flutterApplicationXv/render');
  
  /// 调用原生层渲染内容
  /// [backgroundColor] 背景颜色
  /// [content] 渲染内容
  static Future<bool> renderContent({
    required String backgroundColor, 
    required String content
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'renderContent',
        {
          'backgroundColor': backgroundColor,
          'content': content,
        },
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('Failed to render content: ${e.message}');
      return false;
    }
  }
}

/// 原生渲染视图
class NativeRenderView extends StatelessWidget {
  final String backgroundColor;
  final String content;
  final double height;

  const NativeRenderView({
    Key? key,
    required this.backgroundColor,
    required this.content,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 在Android和iOS上使用平台特定视图
    if (defaultTargetPlatform == TargetPlatform.android) {
      return SizedBox(
        height: height,
        child: AndroidView(
          viewType: 'com.example.flutterApplicationXv/nativeView',
          creationParams: {
            'backgroundColor': backgroundColor,
            'content': content,
          },
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return SizedBox(
        height: height,
        child: UiKitView(
          viewType: 'com.example.flutterApplicationXv/nativeView',
          creationParams: {
            'backgroundColor': backgroundColor,
            'content': content,
          },
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else {
      // 在不支持的平台上显示占位符
      return Container(
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text('不支持的平台'),
        ),
      );
    }
  }
} 