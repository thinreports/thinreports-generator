# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::Pdf::Graphics::TestAttributes < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  class TestAttrs
    include ThinReports::Generator::Pdf::Graphics    
  end
  
  def setup
    @attrs = TestAttrs.new
  end
  
  def test_common_graphic_attrs
    result = @attrs.common_graphic_attrs('stroke'       => '#ff0000',
                                         'stroke-width' => '1',
                                         'fill'         => '#0000ff')
    assert_equal result.values_at(:stroke, :stroke_width, :fill),
                 ['#ff0000', '1', '#0000ff']
  end
  
  def test_common_graphic_attrs_with_stroke_dasharray
    result1 = @attrs.common_graphic_attrs('stroke-dasharray' => '3,5')
    result2 = @attrs.common_graphic_attrs('stroke-dasharray' => 'none')
    result3 = @attrs.common_graphic_attrs({})
    
    assert_equal result1[:stroke_dash], %w( 3 5 )
    assert_nil   result2[:stroke_dash]
    assert_nil   result3[:stroke_dash]
  end
  
  def test_common_graphic_attrs_set_0_to_stroke_width_when_opacity_is_0
    result = @attrs.common_graphic_attrs('stroke-width' => '1',
                                         'stroke-opacity' => '0')
    assert_equal result[:stroke_width], 0
  end
  
  def test_common_graphic_attrs_with_block
    result = @attrs.common_graphic_attrs('stroke' => '#ff0000') do |attrs|
      attrs[:stroke].gsub!(/0/, 'f')
    end
    assert_equal result[:stroke], '#ffffff'
  end
  
  def test_text_align
    aligns = ['start', 'middle', 'end', nil]
    assert_equal aligns.map {|a| @attrs.text_align(a) },
                 [:left, :center, :right, :left]
  end
  
  def test_text_valign
    valigns = ['top', 'center', 'bottom', nil]
    assert_equal valigns.map {|a| @attrs.text_valign(a) },
                 [:top, :center, :bottom, :top]
  end
  
  def test_extract_base64_string
    base64 = 'data:image/png;base64,iVBORw0KGg1+/AAy/plYlzil'
    assert_equal @attrs.extract_base64_string(base64),
                 'iVBORw0KGg1+/AAy/plYlzil'
  end
  
  def test_font_styles_with_bold_and_italic
    assert_equal @attrs.font_styles('font-weight' => 'bold'), [:bold]
    assert_equal @attrs.font_styles('font-style' => 'italic'), [:italic]
    
    refute_includes @attrs.font_styles('font-weight' => 'normal'), :bold
    refute_includes @attrs.font_styles('font-style'  => 'normal'), :italic
  end
  
  def test_font_styles_with_underline_and_strikethrough_via_text_decoration
    assert_equal @attrs.font_styles('text-decoration' => 'underline line-through'),
                 [:underline, :strikethrough]
  end
  
  def common_text_attrs
    result = @attrs.common_text_attrs('font-family'     => 'IPAMincho',
                                      'font-size'       => '12',
                                      'fill'            => '#000000',
                                      'text-anchor'     => 'middle',
                                      'font-weight'     => 'bold',
                                      'text-decoration' => 'line-through')
    assert_equal result.values_at(:font, :size, :color, :align, :styles),
                 ['IPAMincho', '12', '#000000', :center, [:bold, :strikethrough]]
  end
  
  def common_text_attrs_with_letter_spacing
    result1 = @attrs.common_text_attrs('letter-spacing' => '5')
    result2 = @attrs.common_text_attrs('letter-spacing' => 'normal')
    
    assert_equal result1[:letter_spacing], '5'
    assert_nil   result2[:letter_spacing]
  end
  
  def common_text_attrs_with_block
    result = @attrs.common_text_attrs('fill' => '#000000') do |attrs|
      attrs[:color].gsub!(/0/, 'f')
    end
    assert_equal result[:color], '#ffffff'
  end
end
