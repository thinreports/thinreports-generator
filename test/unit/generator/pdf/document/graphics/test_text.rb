# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::PDF::Graphics::TestText < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def setup
    @pdf = ThinReports::Generator::PDF::Document.new
    @pdf.internal.start_new_page
  end
  
  def exec_with_font_styles(attrs = nil, font = nil, &block)
    attrs ||= {:styles => [:bold]}
    font  ||= {:name => 'IPAMincho', :size => 18, :color => 'ff0000'}
    
    @pdf.send(:with_font_styles, attrs, font, &block)
  end
  
  def exec_with_text_styles(attrs = {}, &block)
    default_attrs = {:font  => 'Helvetica',
                     :color => 'ff0000',
                     :size  => 18}
    @pdf.send(:with_text_styles, default_attrs.merge(attrs), &block)
  end
  
  def test_with_text_styles_should_not_operate_when_color_is_none
    exec_with_text_styles(:color => 'none') do |attrs, styles|
      flunk
    end
  end
  
  def test_with_text_styles_should_set_leading_via_line_height_attribute
    exec_with_text_styles(:line_height => 30) do |attrs, styles|
      expected = @pdf.send(:text_line_leading,
                           @pdf.send(:s2f, 30),
                           :name => 'Helvetica', :size => 18)
      assert_equal attrs[:leading], expected
    end
  end
  
  def test_with_text_styles_should_not_set_leading_when_line_height_is_not_specified
    exec_with_text_styles do |attrs, styles|
      refute_includes attrs.keys, :leading
    end
  end
  
  def test_with_text_styles_should_set_character_spacing_via_letter_spacing_attribute
    exec_with_text_styles(:letter_spacing => 5) do |attrs, styles|
      assert_equal attrs[:character_spacing], @pdf.send(:s2f, 5)
    end
  end
  
  def test_with_text_styles_should_not_set_character_spacing_when_letter_spacing_is_not_specified
    exec_with_text_styles do |attrs, styles|
      refute_includes attrs.keys, :character_spacing
    end
  end
  
  def test_with_text_styles_should_parse_color
    exec_with_text_styles(:color => '#ff0000') do |attrs, styles|
      assert_equal @pdf.internal.fill_color, 'ff0000'
    end
  end
  
  def test_with_font_styles_should_set_fill_color_using_color_of_font
    exec_with_font_styles do |attrs, styles|
      assert_equal @pdf.internal.fill_color, 'ff0000'
    end
  end
  
  def test_with_font_styles_should_perform_manual_style_when_bold_style_cannot_be_applied
    exec_with_font_styles do |attrs, styles|
      assert_empty styles
    end
  end
  
  def test_with_font_styles_should_perform_manual_style_when_italic_style_cannot_be_applied
    exec_with_font_styles do |attrs, styles|
      assert_empty styles
    end
  end
  
  def test_with_font_styles_should_set_stroke_color_using_color_of_font_when_bold_style_cannot_be_applied
    exec_with_font_styles do |attrs, styles|
      assert_equal @pdf.internal.stroke_color, 'ff0000'
    end
  end
  
  def test_with_font_styles_should_set_line_width_calculated_from_font_size_when_bold_style_cannot_be_applied
    exec_with_font_styles do |attrs, styles|
      assert_equal @pdf.internal.line_width, 18 * 0.025
    end
  end
  
  def test_with_font_styles_should_set_mode_to_fill_stroke_when_bold_style_cannot_be_applied
    exec_with_font_styles do |attrs, styles|
      assert_equal attrs[:mode], :fill_stroke
    end
  end
  
  def test_with_font_styles_should_not_perform_a_manual_style_when_bold_style_can_be_applied
    exec_with_font_styles(nil, :name => 'Helvetica', :size => 12, :color => '0000ff') do |attrs, styles|
      assert_includes styles, :bold
    end
  end
  
  def test_with_font_styles_should_not_perform_a_manual_style_when_italic_style_can_be_applied
    exec_with_font_styles({:styles => [:italic]}, :name => 'Helvetica', :size => 12, :color => 'ff0000') do |attrs, styles|
      assert_includes styles, :italic
    end
  end
  
  def test_text_line_leading_should_return_a_specified_leading_value_minus_the_font_height
    font = {:name => 'IPAMincho', :size => 36}
    font_height = @pdf.internal.font(font[:name], :size => font[:size]).height
    
    assert_equal @pdf.send(:text_line_leading, 100, font), 100 - font_height
  end
  
  def test_text_without_line_wrap_should_replace_the_spaces_NBSP
    assert_equal @pdf.send(:text_without_line_wrap, ' ' * 2), Prawn::Text::NBSP * 2
  end
  
  def test_text_box_should_not_raise_PrawnCannotFitError
    @pdf.text_box('foo', 0, 0, 1, 1, :font => 'IPAMincho',
                                     :size => 100,
                                     :color => '000000')
  rescue Prawn::Errors::CannotFit
    flunk('Raise Prawn::Errors::CannotFit.')
  end
  
  def test_text_box_attrs_should_return_a_Hash_containing_a_at_and_width_options
    attrs = @pdf.send(:text_box_attrs, 0, 0, 50, 100)
    
    assert_equal attrs.values_at(:at, :width),
                 [@pdf.send(:pos, 0, 0), @pdf.send(:s2f, 50)]
  end
  
  def test_text_box_attrs_should_return_a_Hash_which_doesnt_contain_the_single_line_option_when_single_is_true_but_overflow_is_expand
    attrs = @pdf.send(:text_box_attrs, 0, 0, 100, 100, :single => true, :overflow => :expand)
    refute attrs.key?(:single_line)
  end
  
  def test_text_box_attrs_should_return_a_Hash_containing_a_single_line_option_when_single_is_true_and_overflow_isnot_expand
    attrs = @pdf.send(:text_box_attrs, 0, 0, 100, 100, :single => true, :overflow => :truncate)
    assert_equal attrs[:single_line], true
  end
  
  def test_text_box_attrs_should_return_a_Hash_which_does_not_contain_a_height_option_when_single_is_true
    attrs = @pdf.send(:text_box_attrs, 0, 0, 100, 100, :single => true)
    refute attrs.key?(:height)
  end
  
  def test_text_box_attrs_should_return_a_Hash_which_does_not_contain_a_single_line_option_when_single_is_not_specified
    attrs = @pdf.send(:text_box_attrs, 0, 0, 100, 100)
    refute attrs.key?(:single_line)
  end
  
  def test_text_box_attrs_should_return_a_Hash_containing_a_height_optin_when_single_is_not_specified
    attrs = @pdf.send(:text_box_attrs, 0, 0, 100, 200)
    assert_equal attrs[:height], 200
  end
end
