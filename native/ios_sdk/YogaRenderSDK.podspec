Pod::Spec.new do |s|
  s.name             = 'YogaRenderSDK'
  s.version          = '0.1.0'
  s.summary          = 'A native iOS SDK for rendering yoga content'
  s.description      = <<-DESC
                      YogaRenderSDK is a native iOS SDK that provides rendering capabilities
                      for yoga content in iOS applications.
                      DESC
  s.homepage         = 'https://github.com/yourusername/yoga-demo'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Your Name' => 'your.email@example.com' }
  s.source           = { :git => 'https://github.com/yourusername/yoga-demo.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '13.4'
  s.swift_version = '5.0'
  
  s.source_files = '*.swift'
  
  s.frameworks = 'UIKit'
end 