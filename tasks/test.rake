# coding: utf-8

namespace :test do
  desc 'Run all unit tests'
  task :unit do
    $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/..'))

    files = Dir['test/unit/**/test_*.rb'] + Dir['test/unit/**/*_spec.rb']
    files.each {|f| require f }
  end
  
  desc 'Run all examples'
  task :example do
    $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/..'))
    
    Dir['test/example/**/*.rb'].each {|f| require f }
  end
end
