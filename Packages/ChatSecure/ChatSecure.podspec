Pod::Spec.new do |spec|
	spec.name         = "ChatSecure"
	spec.version      = "1.0.0"
	spec.summary      = "ChatSecure Framework"
	spec.description  = <<-DESC
	Networking
	DESC
	
	spec.homepage     = "https://www.code4fun.group"
	spec.license      = { :type => 'MIT', :file => 'LICENSE' }
	spec.author       = { "Code4Fun" => "namnh@vmodev.com" }
	spec.ios.deployment_target = "14.0"
	
	spec.source       = { :git => "https://github.com/Code4Fun-Group/ChatSecure.git", :tag => spec.version.to_s }
	spec.source_files = 'ChatSecure/**/*.{swift,h,m,c}'
	spec.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
	
	spec.dependency 'Networking'
	spec.dependency 'SwiftSRP'
	spec.dependency 'SocketRocket'
	spec.dependency 'SignalProtocolObjC'
	spec.dependency 'GoogleWebRTC'
	spec.dependency 'YapDatabase'
	spec.dependency 'Mantle'
	spec.dependency 'GoogleSignIn'
	spec.dependency 'MSAL'
	spec.dependency 'FBSDKLoginKit'
end
