source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

## ignore all warnings from all pods
inhibit_all_warnings!

target 'WeatherApp' do

  ## Analytics
  pod 'Fabric'
  pod 'Crashlytics'

  ## Google
  pod 'GooglePlaces'

  ## Code generator
  #pod 'SwiftGen'

  target 'WeatherAppTests' do
    inherit! :search_paths
    pod 'KIF', :configurations => ['Debug']
  end

end

## If you have slow HDD
ENV['COCOAPODS_DISABLE_STATS'] = "true"