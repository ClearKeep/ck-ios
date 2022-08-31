Pod::Spec.new do |s|
	s.name             = 'CallManager'
	s.version          = '1.0.0'
	s.summary          = 'CallManager framework'
	s.description      = <<-DESC
TODO: Add long description of the pod here.
											 DESC

	s.homepage         = 'https://github.com/mq162/CallManager'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'mq162' => 'pmquang162@gmail.com' }
	s.source           = { :git => 'https://github.com/mq162/CallManager.git', :tag => s.version.to_s }

	s.ios.deployment_target = '15.0'

	s.source_files = 'CallManager/**/*.{swift,h,m,c}'
	s.pod_target_xcconfig = {
		'ENABLE_BITCODE' => 'NO',
	}
	
	s.dependency 'GoogleWebRTC'
	s.dependency 'SocketRocket'
	s.dependency 'ChatSecure'
#	s.dependency 'Networking'
#	s.dependency 'ChatSecure'
	
end
