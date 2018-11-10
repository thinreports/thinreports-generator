require 'rake/testtask'
require 'yard'

task default: :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = Dir['test/units/**/test_*.rb']
end

namespace :examples do
  desc 'Run all examples'
  task :all do
    require_relative 'examples/helper'
    Dir['examples/*/*.rb'].each { |f| require_relative f }
  end

  Dir['examples/*/*.rb'].each do |f|
    casename = File.basename(File.dirname(f))

    desc "Run example: #{casename}"
    task casename.to_sym do
      require_relative 'examples/helper'
      require_relative "examples/#{casename}/#{casename}"
    end
  end
end

desc 'Run all examples'
task examples: :'examples:all'

YARD::Rake::YardocTask.new :doc do |yard|
  yard.files = Dir['lib/**/*.rb']
  yard.options = ['--readme', 'README.md']
end
