platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'RxSwift',    '3.4.1'

  # UI
  pod 'UIColor_Hex_Swift', '3.0.2'
  pod 'SDWebImage', '4.0.0'
  pod 'Timepiece', :git => 'https://github.com/skofgar/Timepiece.git', :branch => 'swift3'
  pod 'ALCameraViewController', '1.3.1'
  pod 'KVNProgress', '2.3.1'

  # MarkDown
  pod 'SwiftyMarkdown', '0.3.0'

  # Code generation
  pod 'R.swift', '3.2.0'
end

target 'boilerplate' do
  shared_pods
end

abstract_target 'tests' do
  shared_pods

  platform :ios, '9.0'
  target 'boilerplateTests'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
