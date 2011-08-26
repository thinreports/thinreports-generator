# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::Pdf::TestConfiguration < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def setup
    @config = ThinReports::Generator::Pdf::Configuration.new
  end
  
  def test_cache_template_should_return_false_by_default
    assert_equal @config.cache_template, false
  end
  
  def test_cache_template_properly_set_false_or_path_string
    @config.cache_template = '/path/to/template/dir'
    assert_equal @config.cache_template, '/path/to/template/dir'
  end
  
  def test_eudc_ttf_should_only_set_TTF_file
    assert_raises ArgumentError do
      @config.eudc_ttf = '/path/to/eudc'
    end
    assert_raises ArgumentError do
      @config.eudc_ttf = %w( /path/to/eudc1.ttf /path/to/eudc2 )
    end
  end
end