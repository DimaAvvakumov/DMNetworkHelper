Pod::Spec.new do |s|

  s.name         = "DMNetworkHelper"
  s.version      = "1.9.0"
  s.summary      = "Helper for perform network requests"
  s.homepage     = "https://github.com/DimaAvvakumov/DMNetworkHelper.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Dmitry Avvakumov" => "avvakumov@it-baker.ru" }
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/DimaAvvakumov/DMNetworkHelper.git" }
  s.source_files = "classes/*.{h,m}"
  s.public_header_files = "classes/*.{h}"
  s.framework    = "UIKit"
  s.requires_arc = true

  s.dependency 'AFNetworking', '> 3'
  s.dependency 'StandardPaths'

end
