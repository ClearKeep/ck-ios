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
	spec.ios.deployment_target = "13.0"
	
	spec.source       = { :git => "https://github.com/Code4Fun-Group/ChatSecure.git", :tag => spec.version.to_s }
	spec.source_files = 'ChatSecure/**/*.{swift,h,m,c}'
	
	spec.dependency 'SocketRocket'
	spec.dependency 'SignalProtocolObjC'
	spec.dependency 'GoogleWebRTC'
	spec.dependency 'YapDatabase'
	spec.dependency 'Mantle'
	spec.dependency 'RealmSwift'
	spec.dependency 'gRPC-Swift'
	spec.dependency 'SwiftProtobuf'
	spec.dependency 'CryptoSwift'
	spec.dependency 'OpenSSL-Universal'
end

