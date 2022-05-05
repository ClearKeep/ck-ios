Pod::Spec.new do |spec|
	spec.name         = "CommonUI"
	spec.version      = "1.0.0"
	spec.summary      = "CommonUI Framework"
	spec.description  = <<-DESC
	Networking
	DESC
	
	spec.homepage     = "https://www.code4fun.group"
	spec.license      = { :type => 'MIT', :file => 'LICENSE' }
	spec.author       = { "Code4Fun" => "namnh@vmodev.com" }
	spec.ios.deployment_target = "14.0"
	
	spec.source       = { :git => "https://github.com/Code4Fun-Group/CommonUI.git", :tag => spec.version.to_s }
	spec.source_files = 'CommonUI/**/*.{swift,h,m,c}'
	
	spec.dependency 'Common'
	spec.dependency 'Introspect'
end

