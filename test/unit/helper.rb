# coding: utf-8

begin
  require 'rubygems'
  require 'minitest/unit'
  require 'minitest/spec'
  require 'flexmock'
rescue LoadError => e
  $stderr.puts 'To run the unit tests, you need minitest and flexmock.'
  raise e
end

# Run a test automaticaly
MiniTest::Unit.autorun

# Load misc
require 'digest/sha1'

module ThinReports::TestHelpers
  include FlexMock::TestCase
  
  def clean_whitespaces(str)
    str.gsub(/^\s*|\n\s*/, '')
  end
  
  def skip_if_ruby19
    if RUBY_VERSION > '1.9'
      skip('This test is not required more than Ruby 1.9.')
    end
  end
  
  def skip_if_ruby18
    if RUBY_VERSION < '1.9'
      skip('This test is not required Ruby 1.8 below.')
    end
  end
  
  def create_basic_report(file, &block)
    report = ThinReports::Report.new :layout => data_file(file)
    block.call(report) if block_given?
    report
  end
  
  def create_basic_layout(file)
    ThinReports::Layout.new(data_file(file))
  end
  
  def create_basic_layout_format(file)
    ThinReports::Layout::Format.build(data_file(file))
  end
  
  def data_file(filename)
    File.join(File.dirname(__FILE__), 'data', filename)
  end
end
