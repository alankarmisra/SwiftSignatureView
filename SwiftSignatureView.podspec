Pod::Spec.new do |s|
  s.name             = "SwiftSignatureView"
  s.version          = "3.2.0"
  s.summary          = "A lightweight, fast and customizable option for capturing signatures within your app. Uses PencilKit for iOS13+"

  s.description      = <<-DESC
                       SwiftSignatureView is a lightweight, fast and customizable option for capturing signatures within your app. You can retrieve the signature as a UIImage. With code that varies the pen width based on the speed of the finger movement, the view generates fluid, natural looking signatures. *And now, with iOS13+, SwiftSignatureView automatically uses PencilKit to provide a native and even more fluid signature experience, including a natural integration with the Apple Pencil which makes SwiftSignatureView even better!*
                       DESC

  s.homepage         = "https://github.com/alankarmisra/SwiftSignatureView"
  s.license          = 'MIT'
  s.author           = { "Alankar Misra" => "alankarmisra@gmail.com" }
  s.source           = { :git => "https://github.com/alankarmisra/SwiftSignatureView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/alankarmisra_'

  s.platform     = :ios, '8.3'
  s.swift_version = '5.0.3'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
