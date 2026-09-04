# Uncomment the next line to define a global platform for your project
# platform :ios, '16.0'

target 'Zyvo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Zyvo
    pod 'DropDown', '~> 2.3'
    pod 'FSCalendar', '~> 2.8'
    pod 'Fastis', '~> 2.0'
    pod 'IQKeyboardManagerSwift'
    pod 'Stripe'
    pod 'FBSDKLoginKit'
    pod 'FBSDKCoreKit'
    pod 'ProgressHUD'
    pod 'YPImagePicker'
    pod 'GoogleSignIn'
    pod 'SDWebImage'
    pod 'MBProgressHUD'
    pod 'FirebaseMessaging'
    pod 'FirebaseAnalytics'
    pod 'Alamofire'
    pod 'SwiftyJSON', '~> 4.0'
    pod 'NVActivityIndicatorView'
    pod 'ReachabilitySwift'
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'lottie-ios', '~> 4.0'
    pod 'FBSDKLoginKit'
    pod 'Firebase/Crashlytics'
    pod 'CountryPickerView'
    pod 'TTGTagCollectionView'
    pod 'KDCircularProgress'
    pod 'Cosmos'
    pod 'RangeSeekSlider'
    pod 'PersonaInquirySDK2'
     pod 'ISEmojiView'
    #pod 'TwilioConversationsClient', '~> 3.1'
    pod 'TwilioConversationsClient'
     pod 'AppsFlyerFramework'
    # pod 'libPhoneNumber-iOS'
pod 'PhoneNumberKit', '~> 3.3.3'

  target 'ZyvoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ZyvoUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
    end
  end
  
  # Xcode 14.3+ CocoaPods readlink fix for framework rsync script
  installer.aggregate_targets.each do |target|
    shell_script_path = File.join(installer.sandbox.target_support_files_root, target.label, "#{target.label}-frameworks.sh")
    if File.exist?(shell_script_path)
      file_content = File.read(shell_script_path)
      file_content.gsub!("source=\"$(readlink \"${source}\")\"", "source=\"$(readlink -f \"${source}\")\"")
      File.write(shell_script_path, file_content)
    end
  end
end
