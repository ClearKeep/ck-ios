Pod::Spec.new do |spec|
	spec.name         = "SwiftSRP"
	spec.version      = "1.0.0"
	spec.summary      = "SwiftSRP Framework"
	spec.description  = <<-DESC
	Networking
	DESC
	
	spec.homepage     = "https://www.code4fun.group"
	spec.license      = { :type => 'MIT', :file => 'LICENSE' }
	spec.author       = { "Code4Fun" => "namnh@vmodev.com" }
	spec.ios.deployment_target = "15.0"
	
	spec.source       = { :git => "https://github.com/Code4Fun-Group/SwiftSRP.git", :tag => spec.version.to_s }
	spec.source_files = 'SwiftSRP/**/*.{swift,h,m,c}'
	
	spec.dependency 'CryptoSwift'
	spec.dependency 'OpenSSL-Universal'
end

