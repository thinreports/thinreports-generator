# coding: utf-8

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = Dir['test/unit/**/test_*.rb'] +
                 Dir['test/unit/**/*_spec.rb']
end
