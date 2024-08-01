require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::UI.puts "[react-native-ui-document-interaction] Thank you for using react-native-ui-document-interaction ❤️"


Pod::Spec.new do |s|
  s.name         = "react-native-ui-document-interaction"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/runtimerevolution/react-native-ui-document-interaction.git", :tag => "#{s.version}" }

  s.source_files = [
    "ios/**/*.{h,m,mm}",    
  ]

  install_modules_dependencies(s)
end