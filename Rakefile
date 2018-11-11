require 'rake/testtask'

task default: :test

Rake::TestTask.new do |t|
  t.name = 'test:units'
  t.description = 'Run unit tests'
  t.libs << 'test'
  t.test_files = Dir['test/units/**/test_*.rb']
end

Rake::TestTask.new do |t|
  t.name = 'test:features'
  t.description = 'Run feature tests'
  t.libs << 'test/features'
  t.test_files = Dir['test/features/*/test_*.rb']
  t.warning = false
end

desc 'Run unit and feature tests'
task test: %i( test:units test:features )
