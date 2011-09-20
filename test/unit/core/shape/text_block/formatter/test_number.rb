# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::TextBlock::Formatter::TestNumber < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Formatter = ThinReports::Core::Shape::TextBlock::Formatter::Number
  
  def init_formatter(expect_formats)
    format = flexmock({:format_base => '',
                       :format_number_precision => nil,
                       :format_number_delimiter => nil}.merge(expect_formats))
    Formatter.new(format)
  end
  
  def test_apply_precision_formats
    # When precision is 2
    formatter = init_formatter(:format_number_precision => 2)
    
    assert_equal formatter.apply(1.005), '1.01'
    assert_equal formatter.apply(1.004), '1.00'
    assert_equal formatter.apply(1), '1.00'
    # With String value
    assert_equal formatter.apply('999.999'), '1000.00'
    assert_equal formatter.apply('-999.999'), '-1000.00'
    assert_equal formatter.apply('9'), '9.00'
    # Cannot apply, Return the raw value
    assert_equal formatter.apply('invalid value'), 'invalid value'
    
    # When precision is 0
    formatter = init_formatter(:format_number_precision => 0)
    
    assert_equal formatter.apply(1.5), '2'
  end
  
  def test_apply_precision_format_with_basic_format
    formatter = init_formatter(:format_base => '$ {value}',
                               :format_number_precision => 0)
    
    assert_equal formatter.apply(199.5), '$ 200'
  end
  
  def test_apply_delimiter_formats
    # When delimiter is ','
    formatter = init_formatter(:format_number_delimiter => ',')
    
    assert_equal formatter.apply(1000000), '1,000,000'
    assert_equal formatter.apply(-1000000), '-1,000,000'
    assert_equal formatter.apply('1000.0'), '1,000.0'
    assert_equal formatter.apply('-1000.0'), '-1,000.0'
    # Cannot apply, Return the raw value
    assert_equal formatter.apply('invalid value'), 'invalid value'
    
    # When delimiter is whitespace
    formatter = init_formatter(:format_number_delimiter => ' ')
    
    assert_equal formatter.apply(99999), '99 999'
  end
  
  def test_apply_delimiter_format_with_basic_format
    formatter = init_formatter(:format_base => '￥{value}',
                               :format_number_delimiter => ',')
    
    assert_equal formatter.apply(199800), '￥199,800'
  end
  
  def test_apply_all_format
    formatter = init_formatter(:format_base => '-- {value} --',
                               :format_number_delimiter => ',',
                               :format_number_precision => 2)

    assert_equal formatter.apply(95618.88567), '-- 95,618.89 --'
  end
end