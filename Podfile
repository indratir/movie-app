# Uncomment the next line to define a global platform for your project
$iOSVersion = "18.1"
platform :ios, $iOSVersion

target 'MovieApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MovieApp
  pod 'SwiftLint'

  target 'MovieAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MovieAppUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $iOSVersion
    end
  end
end
