# coding: utf-8

$LOAD_PATH.unshift(File.expand_path('../lib/', __FILE__))
require 'thinreports/version'

Gem::Specification.new do |s|
  s.name        = 'thinreports'
  s.version     = ThinReports::VERSION
  s.author      = 'Matsukei Co.,Ltd.'
  s.email       = 'thinreports@gmail.com'
  s.summary     = 'An open source report generating tool for Ruby.'
  s.description = 'Thinreports is an open source report generating tool for Ruby.'
  s.homepage    = 'http://www.thinreports.org'
  s.licenses    = ['MIT']

  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.3'

  s.rdoc_options     = ['--main', 'README.md']
  s.extra_rdoc_files = ['README.md']

  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep %r{^test/}
  s.require_paths = ['lib']

  s.add_dependency 'prawn', '0.12.0'

  s.add_development_dependency 'bundler', ['>= 1.0.0']
  s.add_development_dependency 'minitest', ['>= 5.0.0']
  s.add_development_dependency 'flexmock', ['>= 1.3.0']
  s.add_development_dependency 'rake', ['>= 0']
end
