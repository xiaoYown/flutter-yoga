import Flutter
import UIKit

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
  private var _textLabel: UILabel = UILabel()
  
  init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
    super.init()
    
    // 初始化容器视图
    _view = UIView(frame: frame)
    _view.backgroundColor = UIColor.white
    
    // 初始化文本标签
    _textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    _textLabel.textAlignment = .center
    _textLabel.numberOfLines = 0
    _textLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    // 添加到视图层次结构
    _view.addSubview(_textLabel)
    
    // 更新视图内容
    updateViewWithArgs(args: args)
  }
  
  func view() -> UIView {
    return _view
  }
  
  private func updateViewWithArgs(args: Any?) {
    // 获取渲染参数
    guard let params = args as? [String: Any] else {
      _textLabel.text = "参数无效"
      return
    }
    
    // 设置背景颜色
    if let backgroundColor = params["backgroundColor"] as? String {
      _view.backgroundColor = hexStringToUIColor(hex: backgroundColor)
    }
    
    // 设置文本内容
    if let contentValue = params["content"] as? String {
      _textLabel.text = "Native Render: \(contentValue)"
    } else {
      _textLabel.text = "Native Render: 默认内容"
    }
    
    // 通知渲染完成
    print("iOS - NativeView: 渲染完成，viewId: \(_view.hash)")
  }
  
  // 将十六进制颜色字符串转换为 UIColor
  private func hexStringToUIColor(hex: String) -> UIColor {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    // 默认为白色
    if hexSanitized.isEmpty {
      return UIColor.white
    }
    
    var rgb: UInt64 = 0
    
    if !Scanner(string: hexSanitized).scanHexInt64(&rgb) {
      return UIColor.white
    }
    
    let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgb & 0x0000FF) / 255.0
    
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
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
  
  // 原生渲染方法
  private func renderContent(backgroundColor: String, content: String) -> Bool {
    print("iOS: 渲染内容 - 背景颜色: \(backgroundColor), 内容: \(content)")
    
    // 这里可以进行实际的渲染操作，例如创建视图并添加到主窗口
    // 由于此处仅为示例，我们只打印参数并返回成功
    
    // TODO: 第二阶段将在此处调用 SDK 的渲染方法
    
    return true
  }
}
