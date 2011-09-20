# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::TextBlock::Formatter::TestPadding < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Formatter = ThinReports::Core::Shape::TextBlock::Formatter::Padding
  
  def init_formatter(expect_formats)
    format = flexmock({:format_base           => nil,
                       :format_padding_length => 0,
                       :format_padding_char   => nil,
                       :format_padding_rdir?  => false}.merge(expect_formats))
    Formatter.new(format)
  end
  
  def test_apply_padding_formats_with_left_direction
    formatter = init_formatter(:format_padding_length => 5,
                               :format_padding_char   => '0')
    
    assert_equal formatter.apply(1), '00001'
    assert_equal formatter.apply('日本語'), '00日本語'
  end
  
  def test_apply_padding_formats_should_not_apply_when_character_length_is_short
    formatter = init_formatter(:format_padding_length => 5,
                               :format_padding_char   => '0')
    
    assert_equal formatter.apply('1234567'), '1234567'
  end
  
  def test_apply_padding_formats_with_right_direction
    formatter = init_formatter(:format_padding_length => 5,
                               :format_padding_char   => '0',
                               :format_padding_rdir?  => true)
    
    assert_equal formatter.apply(123), '12300'
  end
  
  def test_apply_padding_format_with_basic_format
    formatter = init_formatter(:format_base           => '[{value}]',
                               :format_padding_length => 10,
                               :format_padding_char   => ' ')

    assert_equal formatter.apply('ABC'), '[       ABC]'
  end
  
  def test_return_raw_value_when_length_is_0
    formatter = init_formatter(:format_padding_length => 0,
                               :format_padding_char   => '0')
    
    assert_same formatter.apply(v = 123), v
    
    # But apply only basic format if have basic-format.
    formatter = init_formatter(:format_base           => '<{value}>',
                               :format_padding_length => 0,
                               :format_padding_char   => '0')
    
    assert_equal formatter.apply(123), '<123>'
  end
  
  def test_return_raw_value_when_char_is_empty
    formatter = init_formatter(:format_padding_length => 10,
                               :format_padding_char   => '')
    
    assert_same formatter.apply(v = '1'), v

    # But apply only basic format if have basic-format.
    formatter = init_formatter(:format_base           => '<{value}>',
                               :format_padding_length => 0,
                               :format_padding_char   => '0')
    
    assert_equal formatter.apply('1'), '<1>'
  end
end