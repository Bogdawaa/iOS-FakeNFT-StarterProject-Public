# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
inhibit_all_warnings!

target 'FakeNFT' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FakeNFT
  pod 'AppMetricaAnalytics', '~> 5.0.0'
  
  target 'FakeNFTTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FakeNFTUITests' do
    # Pods for testing
  end
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 12.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
end
