import Flutter
import UIKit
import YogaRenderSDK

// 原生视图工厂
class NativeViewFactory: NSObject, FlutterPlatformViewFactory {
  private var messenger: FlutterBinaryMessenger
  
  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }
  
  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
    return NativeView(frame: frame, viewId: viewId, args: args, messenger: messenger)
  }
  
  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

// 原生视图实现
class NativeView: NSObject, FlutterPlatformView {
  private var _view: UIView = UIView()
  
  init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
    super.init()
    
    // 初始化容器视图
    _view = UIView(frame: frame)
    
    // 获取渲染参数
    guard let params = args as? [String: Any],
          let backgroundColor = params["backgroundColor"] as? String,
          let content = params["content"] as? String else {
      return
    }
    
    // 使用 SDK 渲染内容，而不是直接在这里实现渲染逻辑
    _ = YogaRenderSDK.shared.renderContent(in: _view, backgroundColor: backgroundColor, content: content)
    
    print("iOS - NativeView: 使用 SDK 渲染完成，viewId: \(_view.hash)")
  }
  
  func view() -> UIView {
    return _view
  }
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    
    // 注册方法通道
    let renderChannel = FlutterMethodChannel(
      name: "com.example.flutterApplicationXv/render",
      binaryMessenger: controller.binaryMessenger)
    
    // 处理方法调用
    renderChannel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }
      
      if call.method == "renderContent" {
        guard let args = call.arguments as? [String: Any],
              let backgroundColor = args["backgroundColor"] as? String,
              let content = args["content"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENTS", 
                             message: "Invalid arguments", 
                             details: nil))
          return
        }
        
        // 调用渲染方法
        let success = self.renderContent(backgroundColor: backgroundColor, content: content)
        result(success)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    // 注册原生视图工厂
    let factory = NativeViewFactory(messenger: controller.binaryMessenger)
    let registrar = self.registrar(forPlugin: "com.example.flutterApplicationXv")!
    registrar.register(
      factory,
      withId: "com.example.flutterApplicationXv/nativeView"
    )
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // 原生渲染方法 - 现在使用 SDK 实现
  private func renderContent(backgroundColor: String, content: String) -> Bool {
    print("iOS: 调用 SDK 渲染内容 - 背景颜色: \(backgroundColor), 内容: \(content)")
    
    // 创建临时视图用于测试 SDK 渲染功能
    let testView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
    
    // 使用 SDK 渲染内容，而不是直接在这里实现渲染逻辑
    return YogaRenderSDK.shared.renderContent(in: testView, backgroundColor: backgroundColor, content: content)
  }
}
