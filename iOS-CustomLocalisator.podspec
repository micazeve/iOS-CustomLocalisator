Pod::Spec.new do |s|
  s.name         = "iOS-CustomLocalisator"
  s.version      = "1.0"
  s.summary      = "A custom localisator class which allows to change the app language without having to restart it."

  s.description  = <<-DESC
                    Localisator is a small class you can use in order to change languages from within your iOS app, without having to restart it. It’s compatible with the localizable.strings file, so you don’t have to duplicate all your localized strings.
                    DESC
  s.homepage     = "https://github.com/micazeve/iOS-CustomLocalisator"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author             = { "Michaël Azevedo" => "micazeve@gmail.com" }
  s.social_media_url   = "https://twitter.com/micazeve"
  s.platforms	 = { :ios => "8.0" }

  s.source       = { :git => "https://github.com/micazeve/iOS-CustomLocalisator.git", :branch => "master", :tag => '1.0'}
  s.source_files = "Localisator/*.swift"

  s.ios.deployment_target = '8.0'

  s.framework  = "Foundation"
  s.requires_arc = true
end
