# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::PDF::TestConfiguration < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def setup
    @config = ThinReports::Generator::PDF::Configuration.new
  end
  
  def test_eudc_fonts_can_only_set_font_of_TTF
    assert_raises ArgumentError do
      @config.eudc_fonts = '/path/to/eudc'
    end
    assert_raises ArgumentError do
      @config.eudc_fonts = %w( /path/to/eudc1.ttf /path/to/eudc2 )
    end
  end
  
  def test_eudc_fonts_should_return_empty_array_by_default
    assert_equal @config.eudc_fonts, []
  end
end