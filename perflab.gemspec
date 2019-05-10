Gem::Specification.new do |s|
  s.name        = 'perflab'
  s.version     = '0.1.1'
  s.date        = '2019-05-08'
  s.summary     = 'Ruby performance lab'
  s.description = 'Library to profile and benchmark Ruby code'
  s.authors     = ['Mert Guldur']
  s.email       = 'mertguldur@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.license     = 'MIT'

  s.add_dependency 'activesupport'
  s.add_dependency 'benchmark-ipsa'
  s.add_dependency 'stackprof'
  s.add_dependency 'zeitwerk'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
end
