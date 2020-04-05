Pod::Spec.new do |s|
  s.name             = 'MoviesSearch'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MoviesSearch.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/olehkudinovolx/MoviesSearch'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'olehkudinovolx' => 'oleh.kudinov@olx.com' }
  s.source           = { :git => 'https://github.com/olehkudinovolx/MoviesSearch.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  
  s.source_files = 'MoviesSearch/Module/**/*.{swift}'

  s.resources = 'MoviesSearch/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld}'

#  Uncomment if static framework, and comment s.resources
#  s.resource_bundles = {
#    'MoviesSearch' => ['MoviesSearch/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld}']
#  }

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'MoviesSearch/Tests/**/*.{swift}'

    test_spec.dependency 'Quick'
    test_spec.dependency 'Nimble'
    test_spec.dependency 'iOSSnapshotTestCase'
  end
  
  s.dependency 'Networking'

# Support versions before iOS 13 
  s.weak_framework = 'SwiftUI'

end
