Pod::Spec.new do |s|
	s.name             = 'SocialAuthentication'
	s.version          = '1.0.0'
	s.summary          = 'SocialAuthentication framework'
	s.description      = <<-DESC
TODO: Add long description of the pod here.
											 DESC

	s.homepage         = 'https://github.com/mq162/SocialAuthentication'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'mq162' => 'pmquang162@gmail.com' }
	s.source           = { :git => 'https://github.com/mq162/SocialAuthentication.git', :tag => s.version.to_s }

	s.ios.deployment_target = '15.0'

	s.source_files = 'SocialAuthentication/**/*.{swift,h,m,c}'
	
	s.dependency 'GoogleSignIn'
	s.dependency 'MSAL'
	s.dependency 'FBSDKLoginKit'
	s.dependency 'Networking'
	s.dependency 'ChatSecure'
	
end
