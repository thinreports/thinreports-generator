# coding: utf-8

require 'test_helper'

class ThinReports::Generator::PDF::TestConfiguration < Minitest::Test
  include ThinReports::TestHelper

  def setup
    @config = ThinReports::Generator::PDF::Configuration.new
  end

  def test_eudc_fonts_is_deprecated
    out, err = capture_io do
      @config.eudc_fonts = []
    end
    assert_includes err, '[DEPRECATION]'
  end

  def test_eudc_fonts_should_be_able_to_set_only_TTF
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
