Pod::Spec.new do |s|

  s.name         = "DMNetworkHelper"
  s.version      = "0.0.1"
  s.summary      = "Helper for perform network requests"
  s.homepage     = "https://github.com/DimaAvvakumov/DMNetworkHelper.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Dmitry Avvakumov" => "avvakumov@it-baker.ru" }
  s.platform     = :ios, "7.0"
  s.dependency   = 'AFNetworking', '> 2'
  s.source       = { :git => "https://github.com/DimaAvvakumov/DMNetworkHelper.git" }
  s.source_files = "classes/*.{h,m}"
  s.public_header_files = "classes/*.{h,m}"
  s.framework    = "UIKit"
  s.requires_arc = true

end
