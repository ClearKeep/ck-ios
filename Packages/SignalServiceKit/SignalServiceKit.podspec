
Pod::Spec.new do |s|
  s.name             = 'SignalServiceKit'
  s.version          = '1.0.0'
  s.summary          = 'SignalServiceKit framework'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/mq162/SignalServiceKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mq162' => 'pmquang162@gmail.com' }
  s.source           = { :git => 'https://github.com/mq162/SignalServiceKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

	s.source_files = 'SignalServiceKit/**/*.{swift,h,m,c}'
	s.pod_target_xcconfig = {
		'ENABLE_BITCODE' => 'NO',
		'OTHER_CFLAGS' => '-DSQLITE_HAS_CODEC',
		'GCC_PREPROCESSOR_DEFINITIONS' => 'SQLITE_HAS_CODEC=1'
	}
	
	s.dependency 'LibSignalClient'
	s.dependency 'SignalCoreKit'
	s.dependency 'Common'
end
