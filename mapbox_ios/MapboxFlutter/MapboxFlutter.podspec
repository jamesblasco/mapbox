#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mapbox_ios.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'MapboxFlutter'
  s.version          = '0.0.1'
  s.summary          = 'Flutter common package for Mapbox.'
  s.description      = <<-DESC
  Flutter common package for Mapbox so it can be reused
                       DESC
  s.homepage         = 'https://github.com/jamesblasco/mapbox'
  s.license          = { :file => 'mapbox_ios/LICENSE' ,  :type => 'MIT'}
  s.author           = { 'Jaime blasco' => 'git@jaimeblasco.com' }
  s.source           = { :git => 'https://github.com/jamesblasco/mapbox.git', :tag=> '0.0.1' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'MapboxMaps' , '10.0.0-beta.15'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
