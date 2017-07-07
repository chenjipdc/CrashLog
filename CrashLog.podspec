Pod::Spec.new do |s|
  s.name         = "CrashLog"
  s.version      = "1.2.1"
  s.summary      = "Show the crash log in your app by a float window"
  s.homepage     = "https://github.com/chenjipdc"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "pdc" => "chenjipdc@yeah.net" }
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/chenjipdc/CrashLog.git", :tag => s.version.to_s }
  s.source_files = "CrashLog/*.{h,m}"
  s.framework    = "UIKit"
  s.requires_arc = true
  s.dependency "FMDB"
end
