# frozen_string_literal: true

require 'test_helper'

class Thinreports::Generator::PDF::TestParseColor < Minitest::Test
  include Thinreports::TestHelper

  class TestColorParser
    include Thinreports::Generator::PDF::ParseColor
  end

  def setup
    @parser = TestColorParser.new
  end

  def test_parse_color_with_hexcolor
    assert_equal @parser.parse_color('#ff0000'), 'ff0000'
    assert_equal @parser.parse_color('000000'), '000000'
  end

  def test_parse_color_with_colorname
    assert_equal @parser.parse_color('red'), 'ff0000'
  end

  def test_parse_color_with_colorname_raise_when_unknown_name_given
    assert_raises Thinreports::Errors::UnsupportedColorName do
      @parser.parse_color('whitesmoke')
    end
  end
end
