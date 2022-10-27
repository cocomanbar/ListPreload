
Pod::Spec.new do |s|
  s.name             = 'ListPreload'
  s.version          = '1.0.0'
  s.summary          = 'A short description of ListPreload.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/cocomanbar/ListPreload'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cocomanbar' => '125322078@qq.com' }
  s.source           = { :git => 'https://github.com/cocomanbar/ListPreload.git', :tag => s.version.to_s }

  s.static_framework = true
  s.ios.deployment_target = '10.0'

  s.source_files = 'ListPreload/Classes/**/*'
  
  s.frameworks = 'UIKit'
  s.dependency 'MJRefresh'
  
end
