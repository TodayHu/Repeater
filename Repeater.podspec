Pod::Spec.new do |s|
  s.name             = "Repeater"
  s.version          = "0.1.0"
  s.summary          = "Swift timer on GCD"
  s.description      = <<-DESC
                       Swift timer on GCD
                       DESC
  s.homepage         = "https://github.com/Koshub/Repeater.git"
  s.license          = 'MIT'
  s.author           = { "Konstantin Gerasimov" => "gerasimov.kostja@gmail.com" }
  s.source           = { :git => "https://github.com/Koshub/Repeater.git", :tag => s.version }

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*.swift'
end
