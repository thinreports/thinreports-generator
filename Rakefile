require 'bundler/gem_tasks'
require 'rake/testtask'

task default: :test

Rake::TestTask.new do |t|
  t.name = 'test:main'
  t.description = 'Run tests for main'
  t.libs << 'test/main'
  t.test_files = Dir['test/main/**/test_*.rb']
  t.warning = false
end

Rake::TestTask.new do |t|
  t.name = 'test:basic_report'
  t.description = 'Run tests for basic report'
  t.libs << 'test' << 'test/basic_report'
  t.test_files = Dir['test/basic_report/**/test_*.rb']
end

Rake::TestTask.new do |t|
  t.name = 'test:section_report'
  t.description = 'Run tests for section report'
  t.libs << 'test' << 'test/section_report'
  t.test_files = Dir['test/section_report/**/test_*.rb']
  t.warning = false
end

desc 'Run all tests'
task test: %i(test:main test:basic_report test:section_report)
