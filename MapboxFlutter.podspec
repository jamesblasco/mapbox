Pod::Spec.new do |s|
  s.name             = 'MapboxFlutter'
  s.version          = '0.0.5'
  s.summary          = 'Flutter common package for Mapbox.'
  s.description      = <<-DESC
  Flutter common package for Mapbox so it can be reused
                       DESC
  s.homepage         = 'https://github.com/jamesblasco/mapbox'
  s.license          = { :file => 'mapbox_ios/LICENSE' ,  :type => 'MIT'}
  s.author           = { 'Jaime blasco' => 'git@jaimeblasco.com' }
  s.source           = { :git => 'https://github.com/jamesblasco/mapbox.git', :tag=> s.version, :branch => 'main' }
  s.source_files = 'mapbox_ios/MapboxFlutter/Classes/**/*'
  s.dependency 'Flutter', '2.0.0'
  s.dependency 'MapboxMaps' , '10.0.0-beta.15'
  s.platform = :ios, '11.0'


  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 x86_64', 'ONLY_ACTIVE_ARCH' => 'YES' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 x86_64','ONLY_ACTIVE_ARCH' => 'YES' }
  s.swift_version = '5.0'
end
