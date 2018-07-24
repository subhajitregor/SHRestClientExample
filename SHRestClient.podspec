Pod::Spec.new do |s|
  s.name             = 'SHRestClient'
  s.version          = '1.0.0'
  s.summary          = 'Easy to use basic rest client.'
 
  s.description      = <<-DESC
If you donot like a bunch of code for a rest api call and want to keep your code boilerplate code free, this is for you.
                       DESC
 
  s.homepage         = 'https://github.com/subhajitregor/SHRestClientExample'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'subhajitregor' => 'subhajit.regor@gmail.com' }
  s.source           = { :git => 'https://github.com/subhajitregor/SHRestClientExample.git', :tag => s.version.to_s }
 
  s.swift_version = '4.0'
  s.ios.deployment_target = '10.3'
  s.source_files = 'SHRestClient/*',
  'SHRestClient/ReachabilitySwift/*',
  'SHRestClient/Resource/*',
  'SHRestClient/NoConnectionVC/*'
 
end