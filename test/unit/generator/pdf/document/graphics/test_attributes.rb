# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::PDF::Graphics::TestAttributes < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def setup
    @pdf = ThinReports::Generator::PDF::Document.new
  end
  
  def test_common_graphic_attrs_should_return_converted_Hash_as_attributes
    result = @pdf.common_graphic_attrs('stroke'       => '#ff0000',
                                       'stroke-width' => '1',
                                       'fill'         => '#0000ff')
    assert_equal result.values_at(:stroke, :stroke_width, :fill),
                 ['#ff0000', '1', '#0000ff']
  end
  
  def test_common_graphic_attrs_should_return_the_stroke_dash_attribute_into_an_array
    result = @pdf.common_graphic_attrs('stroke-dasharray' => '3,5')
    assert_equal result[:stroke_dash], %w( 3 5 )
  end
  
  def test_common_graphic_attrs_should_return_nil_as_a_value_of_stroke_dash_attribute_when_value_is_none
    result = @pdf.common_graphic_attrs('stroke-dasharray' => 'none')
    assert_nil result[:stroke_dash]
  end
  
  def test_common_graphic_attrs_should_return_nil_as_a_value_of_stroke_dash_attribute_when_value_is_empty
    result = @pdf.common_graphic_attrs({})
    assert_nil result[:stroke_dash]
  end
  
  def test_common_graphic_attrs_should_set_0_as_a_value_of_stroke_width_attribute_when_opacity_is_0
    result = @pdf.common_graphic_attrs('stroke-width'   => '1',
                                       'stroke-opacity' => '0')
    assert_equal result[:stroke_width], 0
  end
  
  def test_common_graphic_attrs_with_block
    result = @pdf.common_graphic_attrs('stroke' => '#ff0000') do |attrs|
      attrs[:stroke].gsub!(/0/, 'f')
    end
    assert_equal result[:stroke], '#ffffff'
  end
  
  def test_text_align_should_return_converted_value_type_of_Symbol
    aligns = ['start', 'middle', 'end', nil]
    assert_equal aligns.map {|a| @pdf.text_align(a) },
                 [:left, :center, :right, :left]
  end
  
  def test_text_valign_should_return_converted_value_type_of_Symbol
    valigns = ['top', 'center', 'bottom', nil]
    assert_equal valigns.map {|a| @pdf.text_valign(a) },
                 [:top, :center, :bottom, :top]
  end
  
  def test_extract_base64_string
    base64 = 'data:image/png;base64,iVBORw0KGg1+/AAy/plYlzil'
    assert_equal @pdf.extract_base64_string(base64),
                 'iVBORw0KGg1+/AAy/plYlzil'
  end
  
  def test_font_styles_should_return_bold_style_when_font_weight_is_bold
    assert_equal @pdf.font_styles('font-weight' => 'bold'), [:bold]
  end
  
  def test_font_styles_should_return_italic_style_when_font_style_is_italic
    assert_equal @pdf.font_styles('font-style' => 'italic'), [:italic]
  end
  
  def test_font_styles_should_return_underline_and_strikethrough_style_via_text_decoration
    assert_equal @pdf.font_styles('text-decoration' => 'underline line-through'),
                 [:underline, :strikethrough]
  end
  
  def test_common_text_attrs_should_return_the_value_of_font_family_as_font
    result = @pdf.common_text_attrs('font-family' => 'IPAMincho')
    assert_equal result[:font], 'IPAMincho'
  end
  
  def test_common_text_attrs_should_return_the_value_of_font_size_as_size
    result = @pdf.common_text_attrs('font-size' => '12')
    assert_equal result[:size], '12'
  end
  
  def test_common_text_attrs_should_return_the_value_of_fill_color_as_color
    result = @pdf.common_text_attrs('fill' => '#000000')
    assert_equal result[:color], '#000000'
  end
  
  def test_common_text_attrs_should_return_the_value_of_text_anchor_as_align
    result = @pdf.common_text_attrs('text-anchor' => 'middle')
    assert_equal result[:align], :center
  end
  
  def test_common_text_attrs_should_return_the_value_of_text_styles_as_styles
    result = @pdf.common_text_attrs('font-weight' => 'bold')
    assert_equal result[:styles], [:bold]
  end
  
  def test_common_text_attrs_should_return_the_value_of_letter_spacing_as_letter_spacing
    result = @pdf.common_text_attrs('letter-spacing' => '5')
    assert_equal result[:letter_spacing], '5'
  end
  
  def test_common_text_attrs_should_return_the_value_of_kerning_as_letter_spacing
    result = @pdf.common_text_attrs('kerning' => '10')
    assert_equal result[:letter_spacing], '10'
  end
  
  def test_common_text_attrs_with_block
    result = @pdf.common_text_attrs('fill' => '#000000') do |attrs|
      attrs[:color].gsub!(/0/, 'f')
    end
    assert_equal result[:color], '#ffffff'
  end
  
  def test_text_letter_spacing_should_return_raw_value
    assert_equal @pdf.text_letter_spacing('10'), '10'
  end
  
  def test_text_letter_spacing_should_return_nil_when_value_is_normal
    assert_nil @pdf.text_letter_spacing('normal')
  end
  
  def test_text_letter_spacing_should_return_nil_when_value_is_auto
    assert_nil @pdf.text_letter_spacing('auto')
  end

  def test_text_overflow
    assert_equal @pdf.text_overflow('truncate'), :truncate
    assert_equal @pdf.text_overflow('fit'), :shrink_to_fit
    assert_equal @pdf.text_overflow('expand'), :expand
    assert_equal @pdf.text_overflow(''), :truncate
  end
end
