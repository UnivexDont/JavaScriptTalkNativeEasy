Pod::Spec.new do |s|
  s.name             = 'JavaScriptTalkNatvieEasy'
  s.version          = '1.0.0'
  s.summary          = 'A library for objc and JavaScript'
  s.homepage         = 'https://github.com/UnivexDont/JavaScriptTalkNativeEasy'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'UnivexDont' => 'winerdt@163.com' }
  s.source           = { :git => 'https://github.com/UnivexDont/JavaScriptTalkNativeEasy.git', :tag => "#{s.version}" }

  s.ios.deployment_target = '8.0'
  s.source_files = 'JavaScriptTalkNativeEasy/Source/Core/*.{h,m}'
  s.ios.frameworks   = 'UIKit', 'WebKit','JavaScriptCore'
end