Pod::Spec.new do |s|
  s.name             = 'Authentication'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Authentication.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
                   
  s.homepage         = 'https://github.com/olehkudinovolx/Authentication'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'olehkudinovolx' => 'oleh.kudinov@olx.com' }
  s.source           = { :git => 'https://github.com/olehkudinovolx/Authentication.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Authentication/Module/**/*.{swift}'

  s.resources = 'Authentication/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld}'
    
  # 3rd party frameworks
  s.dependency 'Alamofire', '4.9.1'
  
end
