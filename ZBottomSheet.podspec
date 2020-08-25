#
# Be sure to run `pod lib lint ZBottomSheet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZBottomSheet'
  s.version          = '0.5.0'
  s.summary          = 'BottomSheet is simple to use bottom sheet for iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'BottomSheet is simple to use bottom sheet where you can attach navigation bar, uiview, table view and collection view on it.'
                       DESC

  s.homepage         = 'https://github.com/sxudan/ZBottomSheet'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sxudan' => 'sudan.suwal@spiralogics.com' }
  s.source           = { :git => 'https://github.com/sxudan/ZBottomSheet.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  
  s.swift_version = '5.0'
  
  s.platforms = {
      "ios": "12.0"
  }
  
  #  s.source_files = 'BottomSheet/Classes/**/*'
  
  s.source_files = 'Source/**/*'
  
  # s.resource_bundles = {
  #   'ZBottomSheet' => ['ZBottomSheet/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
