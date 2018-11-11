# frozen_string_literal: true

rootdir = File.expand_path(File.dirname(__FILE__))

require "#{rootdir}/lib/thinreports/version"

Gem::Specification.new do |s|
  s.name        = 'thinreports'
  s.version     = Thinreports::VERSION
  s.author      = 'Matsukei Co.,Ltd.'
  s.email       = 'thinreports@gmail.com'
  s.summary     = 'An open source report generation tool for Ruby.'
  s.description = 'Thinreports is an open source report generation tool for Ruby.'
  s.homepage    = 'http://www.thinreports.org'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.1.0'

  s.files = `git ls-files`.split($\)
  s.require_path = 'lib'

  s.add_dependency 'prawn', '~> 2.2.0'

  s.add_development_dependency 'bundler', '>= 1.0.0'
  s.add_development_dependency 'minitest', '>= 5.0.0'
  s.add_development_dependency 'mocha', '>= 0'
  s.add_development_dependency 'pdf-inspector', '>= 0'
  s.add_development_dependency 'rake', '>= 0'
end
