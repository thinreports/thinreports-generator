# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Style::TestText < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def create_format(format = {})
    ThinReports::Core::Shape::Text::Format.new(format)
  end
  
  def create_text_style(format = nil)
    format ||= create_format
    ThinReports::Core::Shape::Style::Text.new(format)
  end
  
  def test_bold_should_return_true_when_font_weight_property_of_format_is_bold
    format = create_format('svg' => {'attrs' => {'font-weight' => 'bold'}})
    style  = create_text_style(format)
    
    assert_equal style.bold, true
  end
  
  def test_bold_should_return_false_when_font_weight_property_of_format_is_not_bold
    format = create_format('svg' => {'attrs' => {'font-weight' => 'normal'}})
    style  = create_text_style(format)
    
    assert_equal style.bold, false
  end
  
  def test_bold_should_set_normal_to_font_weight_style_when_value_is_false
    style = create_text_style
    style.bold = false
    
    assert_equal style.styles['font-weight'], 'normal'
  end
  
  def test_bold_should_set_bold_to_font_weight_style_when_value_is_true
    style = create_text_style
    style.bold = true
    
    assert_equal style.styles['font-weight'], 'bold'
  end
  
  def test_bold_should_return_true_when_font_weight_of_internal_style_is_bold
    style = create_text_style
    style.styles['font-weight'] = 'bold'
    
    assert_equal style.bold, true
  end
  
  def test_bold_should_return_false_when_font_weight_of_internal_style_is_not_bold
    style = create_text_style
    style.styles['font-weight'] = 'normal'
    
    assert_equal style.bold, false
  end
  
  def test_italic_should_return_true_when_font_style_property_of_format_is_italic
    format = create_format('svg' => {'attrs' => {'font-style' => 'italic'}})
    style  = create_text_style(format)
    
    assert_equal style.italic, true
  end
  
  def test_italic_should_return_false_when_font_style_property_of_format_is_not_italic
    format = create_format('svg' => {'attrs' => {'font-style' => 'normal'}})
    style  = create_text_style(format)
    
    assert_equal style.italic, false
  end
  
  def test_italic_should_set_normal_to_font_style_style_when_value_is_false
    style = create_text_style
    style.italic = false
    
    assert_equal style.styles['font-style'], 'normal'
  end
  
  def test_italic_should_set_italic_to_font_style_style_when_value_is_true
    style = create_text_style
    style.italic = true
    
    assert_equal style.styles['font-style'], 'italic'
  end
  
  def test_italic_should_return_false_when_font_style_of_internal_style_is_not_italic
    style = create_text_style
    style.styles['font-style'] = 'normal'
    
    assert_equal style.italic, false
  end
  
  def test_italic_should_return_true_when_font_style_of_internal_style_is_italic
    style = create_text_style
    style.styles['font-style'] = 'italic'
    
    assert_equal style.italic, true
  end
  
  def test_underline_should_return_true_when_underline_is_included_in_text_decoration_property_of_format
    format = create_format('svg' => {'attrs' => {'text-decoration' => 'underline line-through'}})
    style  = create_text_style(format)
    
    assert_equal style.underline, true
  end
  
  def test_underline_should_return_false_when_underline_is_not_included_in_text_decoration_property_of_format
    format = create_format('svg' => {'attrs' => {'text-decoration' => 'line-through'}})
    style  = create_text_style(format)
    
    assert_equal style.underline, false
  end
  
  def test_underline_should_return_true_when_underline_is_included_in_text_decoration_of_internal_style
    style = create_text_style
    style.styles['text-decoration'] = 'underline line-through'
    
    assert_equal style.underline, true
  end
  
  def test_underline_should_return_false_when_underline_is_not_included_in_text_decoration_of_internal_style
    style = create_text_style
    style.styles['text-decoration'] = 'none'
    
    assert_equal style.underline, false
  end
  
  def test_underline_should_include_underline_in_text_decoration_when_value_is_true
    format = create_format('svg' => {'attrs' => {'text-decoration' => 'line-through'}})
    style  = create_text_style(format)
    style.underline = true
    
    assert_includes style.styles['text-decoration'], 'underline'
  end
  
  def test_underline_should_remove_underline_from_text_decoration_when_value_is_false
    format = create_format('svg' => {'attrs' => {'text-decoration' => 'underline line-through'}})
    style  = create_text_style(format)
    style.underline = false
    
    refute_includes style.styles['text-decoration'], 'underline'
  end
  
  def test_linethrough_should_return_true_when_line_through_is_included_in_text_decoration_property_of_format
    format = create_format('svg' => {'attrs' => {'text-decoration' => 'underline line-through'}})
    style  = create_text_style(format)
    
    assert_equal style.linethrough, true
  end
  
  def test_linethrough_should_return_false_when_line_through_is_not_included_in_text_decoration_property_of_format
    format = create_format('svg' => {'attrs' => {'text-decoration' => 'underline'}})
    style  = create_text_style(format)
    
    assert_equal style.linethrough, false
  end
  
  def test_linethrough_should_return_true_when_line_through_is_included_in_text_decoration_of_internal_style
    style = create_text_style
    style.styles['text-decoration'] = 'underline line-through'
    
    assert_equal style.linethrough, true
  end
  
  def test_linethrough_should_return_false_when_line_through_is_not_included_in_text_decoration_of_internal_style
    style = create_text_style
    style.styles['text-decoration'] = 'underline'
    
    assert_equal style.linethrough, false
  end
  
  def test_linethrough_should_include_line_through_in_text_decoration_when_value_is_true
    format = create_format('svg' => {'attrs' => {'text-decoration' => 'none'}})
    style  = create_text_style(format)
    style.linethrough = true
    
    assert_includes style.styles['text-decoration'], 'line-through'
  end
  
  def test_linethrough_should_remove_line_through_from_text_decoration_when_value_is_false
    format = create_format('svg' => {'attrs' => {'text-decoration' => 'underline line-through'}})
    style  = create_text_style(format)
    style.linethrough = false
    
    refute_includes style.styles['text-decoration'], 'line-through'
  end
  
  def test_text_decoration_should_return_none
    assert_equal create_text_style.send(:text_decoration, false, false), 'none'
  end
  
  def test_text_decoration_should_return_underline
    assert_equal create_text_style.send(:text_decoration, true, false), 'underline'
  end
  
  def test_text_decoration_should_return_line_through
    assert_equal create_text_style.send(:text_decoration, false, true), 'line-through'
  end
  
  def test_text_decoration_should_return_underline_line_through
    assert_equal create_text_style.send(:text_decoration, true, true), 'underline line-through'
  end
  
  def test_interface_text_align_should_return_Symbol_left_when_value_is_undefined
    assert_equal create_text_style.send(:interface_text_align, nil), :left
  end
  
  def test_interface_text_align_should_return_Symbol_left_when_value_is_String_start
    assert_equal create_text_style.send(:interface_text_align, 'start'), :left
  end
  
  def test_interface_text_align_should_return_Symbol_left_when_value_is_unknown_align_type
    assert_equal create_text_style.send(:interface_text_align, 'unknown'), :left
  end
  
  def test_interface_text_align_should_return_Symbol_center_when_value_is_String_middle
    assert_equal create_text_style.send(:interface_text_align, 'middle'), :center
  end
  
  def test_interface_text_align_should_return_Symbol_right_when_value_is_String_end
    assert_equal create_text_style.send(:interface_text_align, 'end'), :right
  end
  
  def test_internal_text_align_should_return_nil_when_value_is_unknown
    assert_equal create_text_style.send(:internal_text_align, :unknown), nil
  end
  
  def test_internal_text_align_should_return_String_start_when_value_is_Symbol_left
    assert_equal create_text_style.send(:internal_text_align, :left), 'start'
  end
  
  def test_internal_text_align_should_return_String_middle_when_value_is_Symbol_center
    assert_equal create_text_style.send(:internal_text_align, :center), 'middle'
  end
  
  def test_internal_text_align_should_return_String_end_when_value_is_Symbol_right
    assert_equal create_text_style.send(:internal_text_align, :right), 'end'
  end
  
  def test_align_should_properly_return_align_type_with_reference_to_text_anchor_property_of_format
    result = []
    
    format_left   = create_format('svg' => {'attrs' => {'text-anchor' => 'start'}})
    format_center = create_format('svg' => {'attrs' => {'text-anchor' => 'middle'}})
    format_right  = create_format('svg' => {'attrs' => {'text-anchor' => 'end'}})
    
    result << create_text_style(format_left).align
    result << create_text_style(format_center).align
    result << create_text_style(format_right).align
    
    assert_equal result, [:left, :center, :right]
  end
  
  def test_copy_should_properly_copy_the_valign_property_of_the_original
    style = create_text_style
    style.valign = :center
    
    assert_equal style.copy.valign, :center
  end
  
  def test_align_should_property_return_align_type_with_reference_to_text_anchor_of_internal_style
    style = create_text_style
    style.styles['text-anchor'] = 'middle'
    
    assert_equal style.align, :center
  end
  
  def test_align_should_set_interface_align_type_to_text_anchor
    style = create_text_style
    style.align = :right
    
    assert_equal style.styles['text-anchor'], 'end'
  end
  
  def test_align_should_raise_when_the_specified_type_is_unknown
    assert_raises ArgumentError do
      create_text_style.align = :unknown
    end
  end
  
  def test_valign_should_return_top_when_valign_of_format_is_blank
    assert_equal create_text_style.valign, :top
  end
  
  def test_valign_should_return_valign_type_of_format_as_default
    format = create_format('valign' => 'bottom')
    style  = create_text_style(format)
    
    assert_equal style.valign, :bottom
  end
  
  def test_valign_should_properly_set_valign_type
    style = create_text_style
    style.valign = :center
    
    assert_equal style.valign, :center
  end
  
  def test_valign_should_raise_when_the_specified_type_is_unknown
    assert_raises ArgumentError do
      create_text_style.valign = :unknonw
    end
  end
  
  def test_identifier_should_return_the_same_value_as_create_identifier_method_when_valign_has_not_been_changed
    style = create_text_style
    assert_equal style.identifier, style.send(:create_identifier, style.styles)
  end
  
  def test_identifier_should_return_the_value_which_added_valign_to_the_value_of_create_identifier_when_valign_has_been_changed
    style = create_text_style
    style.valign = :bottom
    
    assert_equal style.identifier,
                 style.send(:create_identifier, style.styles) + 'bottom'
  end
end