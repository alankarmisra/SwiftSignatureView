Pod::Spec.new do |s|
  s.name             = "SwiftSignatureView"
  s.version          = "0.0.7"
  s.summary          = "A lightweight, fast and customizable option for capturing signatures within your app."

  s.description      = <<-DESC
                       SwiftSignatureView is a lightweight, fast and customizable option for capturing signatures within your app. You can retrieve the signature as a UIImage. 
                       DESC

  s.homepage         = "https://github.com/alankarmisra/SwiftSignatureView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Alankar Misra" => "alankarmisra@gmail.com" }
  s.source           = { :git => "https://github.com/alankarmisra/SwiftSignatureView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/alankarmisra_'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SwiftSignatureView' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
