Pod::Spec.new do |s|
  s.name             = 'Networking'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Networking.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/olehkudinovolx/Networking'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'olehkudinovolx' => 'oleh.kudinov@olx.com' }
  s.source           = { :git => 'https://github.com/olehkudinovolx/Networking.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Networking/Module/**/*.{swift}'
  
  s.resources = 'Networking/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld}'

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Networking/Tests/**/*.{swift}'
  end

end
