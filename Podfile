source 'https://github.com/CocoaPods/Specs.git'

##################
# App
##################
workspace "ClearKeep"
platform :ios, '14.0'

##################
# Global
##################
inhibit_all_warnings!
use_frameworks!


##################
# Pods
##################
def common
	pod 'ChatSecure', :path => './Packages/ChatSecure'
end

def xctools
	pod 'SwiftLint'
end

def analytics
end

def utilities
	pod 'netfox', :configurations => ['Development', 'QA']
end

def ui
end

def shared
	common
	ui
end

##################
# Targets
##################
target 'ClearKeep' do
	# Pods for iOSBase
	shared
	analytics
	utilities
	xctools
end

target 'ClearKeepTests' do
	inherit! :search_paths
	# Pods for testing
end

target 'ClearKeepUITests' do
	# Pods for testing
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			if Gem::Version.new('14.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
				config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
			end
		end
	end

	installer.pods_project.build_configurations.each do |config|
		excluded_environments = ["Production"]
			
		if !excluded_environments.include?(config.name)
			config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
			config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
			config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
			config.build_settings['GCC_OPTIMIZATION_LEVEL'] = '0'
			config.build_settings['SWIFT_COMPILATION_MODE'] = 'singlefile'
			config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
			config.build_settings['MTL_ENABLE_DEBUG_INFO'] = 'YES'
			config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'DEBUG'
		end
	end
end
