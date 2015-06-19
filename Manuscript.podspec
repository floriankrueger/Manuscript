Pod::Spec.new do |s|
  s.name             = "Manuscript"
  s.version          = "0.0.6"
  s.summary          = "AutoLayoutKit in pure Swift."
  s.description      = <<-DESC
                        It's like AutoLayoutKit but written in Swift. For pure Swift projects. And it's super simple.

                        * concise, simple and convenient API
                        * raw AutoLayout power
                        * no black magic involved
                        * fully documented
                        * completely unit-tested
                       DESC
  s.homepage         = "https://github.com/floriankrueger/Manuscript"
  s.license          = 'MIT'
  s.author           = { "Florian Krüger" => "florian.krueger@projectserver.org" }
  s.source           = { :git => "https://github.com/floriankrueger/Manuscript.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/xcuze'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Source/*.swift'
end
