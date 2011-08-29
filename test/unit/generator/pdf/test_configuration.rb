# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::Pdf::TestConfiguration < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def setup
    @config = ThinReports::Generator::Pdf::Configuration.new
  end
  
  def test_cache_templates_should_return_false_by_default
    assert_equal @config.cache_templates, false
  end
  
  def test_cache_templates_can_be_set_string_of_store_dir
    @config.cache_templates = '/path/to/template/dir'
    assert_equal @config.cache_templates, '/path/to/template/dir'
  end
  
  def test_eudc_ttf_can_only_set_font_of_TTF
    assert_raises ArgumentError do
      @config.eudc_ttf = '/path/to/eudc'
    end
    assert_raises ArgumentError do
      @config.eudc_ttf = %w( /path/to/eudc1.ttf /path/to/eudc2 )
    end
  end
  
  def test_eudc_ttf_should_return_empty_array_by_default
    assert_equal @config.eudc_ttf, []
  end
end