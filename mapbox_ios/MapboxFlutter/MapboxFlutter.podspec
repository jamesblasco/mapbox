#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mapbox_ios.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'MapboxFlutter'
  s.version          = '0.0.1'
  s.summary          = 'Flutter common package for Mapbox.'
  s.description      = <<-DESC
  Flutter common package for Mapbox
                       DESC
  s.homepage         = 'https://github.com/jamesblasco/mapbox'
  s.license          = { :file => 'mapbox_ios/LICENSE' }
  s.author           = { 'Jaime blasco' => 'git@jaimeblasco.com' }
  s.source           = { :git => 'https://github.com/jamesblasco/mapbox/' }
  s.source_files = 'mapbox_ios/FlutterMapbox/Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'MapboxMaps' , '10.0.0-beta.15'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
