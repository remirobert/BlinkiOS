use_frameworks!
pod 'ReactiveCocoa', '~> 4.0.2-alpha-1'
pod 'Masonry'
pod 'Parse'
pod 'TwilioSDK'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
        
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end