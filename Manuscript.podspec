Pod::Spec.new do |s|
  s.name = 'Manuscript'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'AutoLayoutKit in pure Swift'
  s.homepage = 'https://github.com/floriankrueger/Manuscript'
  s.social_media_url = 'http://twitter.com/xcuze'
  s.authors = { 'Florian Krüger' => 'florian.krueger@projectserver.org' }
  s.source = { :git => 'https://github.com/floriankrueger/Manuscript.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Source/*.swift'

  s.requires_arc = true
end
