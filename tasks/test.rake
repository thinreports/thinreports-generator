# coding: utf-8

namespace :test do
  desc 'Run all unit tests'
  task :unit do
    $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/..'))

    files = Dir['test/unit/**/test_*.rb'] + Dir['test/unit/**/*_spec.rb']
    files.each {|f| require f }
  end
  
  namespace :case do
    desc 'Run all special test cases [MANAGE_TEMPLATES(false): true/false]'
    task :all do
      $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/..'))
      
      require 'test/case/helper'
      
      Dir['test/case/*/*.rb'].each do |f|
        if ENV['MANAGE_TEMPLATES']
          ThinReports.config.generator.pdf.manage_templates = File.expand_path(File.dirname(f))
        end
        require f
      end
    end
    
    desc 'Reset all output of test cases'
    task :reset do
      File.delete(*Dir['test/case/*/*.pdf'])
    end
    
    Dir['test/case/*/*.rb'].each do |f|
      casename = File.basename(File.dirname(f))
      
      desc "Run #{casename} case [MANAGE_TEMPLATE(false): true/false]"
      task casename.to_sym do
        $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/..'))
        
        require 'test/case/helper'
        
        if ENV['MANAGE_TEMPLATES']
          ThinReports.config.generator.pdf.manage_templates = File.expand_path(File.dirname(f))
        end        
        require "test/case/#{casename}/#{casename}"
      end
    end
  end
  
  desc 'Alias for test:case:all'
  task :case => [:'case:all']
end
