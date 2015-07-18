Pod::Spec.new do |s|
  s.name             = "SwiftSignatureView"
  s.version          = "0.0.6"
  s.summary          = "A lightweight, fast and customizable option for capturing signatures within your app."
  s.description      = <<-DESC
                       SwiftSignatureView is a lightweight, fast and customizable option for capturing signatures within your app. You can retrieve the signature as a UIImage. 
                       DESC
  s.homepage         = "https://github.com/alankarmisra/SwiftSignatureView"
  s.license          = 'MIT'
  s.author           = { "Alankar Misra" => "alankarmisra@gmail.com" }
  s.source           = { :git => "https://github.com/alankarmisra/SwiftSignatureView.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SwiftSignatureView' => ['Pod/Assets/*.png']
  }


  s.frameworks = 'UIKit'

end
