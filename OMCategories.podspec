#
# Be sure to run `pod lib lint OMCategories.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OMCategories'
  s.version          = '0.1.0'
  s.summary          = 'Some useful categories for Foundation and UIKit '

  s.description      = <<-DESC
                        Some useful categories for Foundation and UIKit
                       DESC

  s.homepage         = 'https://github.com/OldMusketeers/OMCategories'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ChengwenY' => 'https://github.com/ChengwenY' }
  s.source           = { :git => 'https://github.com/OldMusketeers/OMCategories.git', :tag => s.version.to_s }
  s.platform         = :ios, '8.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'OMCategories/**/*.{h,m,hh,mm,cpp}'
  s.requires_arc = true


  s.public_header_files = 'OMCategories/**/*.{h,hh}'
  s.library = 'c++', 'z'
  s.frameworks = 'UIKit', 'QuartzCore', 'CoreText'
end
