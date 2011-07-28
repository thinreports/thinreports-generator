# coding: utf-8

require 'yard'

YARD::Rake::YardocTask.new(:doc) do |yard|
  yard.files   = Dir['lib/**/*.rb']
  yard.options = [
    '--no-private', 
    '--readme',     'README.rdoc',
    '--output-dir', 'doc/yardoc', 
    '--template-path', 'doc/yardoc_templates'
  ]
end
