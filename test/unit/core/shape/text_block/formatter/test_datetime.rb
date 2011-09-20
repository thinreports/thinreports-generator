# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::TextBlock::Formatter::TestDatetime < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Formatter = ThinReports::Core::Shape::TextBlock::Formatter::Datetime
  
  def setup
    @datetime_format = '%Y/%m/%d %H:%M:%S'
    @time            = Time.now

    @format = flexmock(:format_base => '', 
                       :format_datetime_format => @datetime_format)
  end
  
  def test_apply_datetime_format_without_basic_format
    formatter = Formatter.new(@format)
    
    assert_equal formatter.apply(@time), @time.strftime(@datetime_format)
  end
  
  def test_apply_datetime_format_with_basic_format
    # Partial mock
    format = flexmock(@format, :format_base => 'Now: {value}')
    
    formatter = Formatter.new(format)
    
    assert_equal formatter.apply(@time),
                 "Now: #{@time.strftime(@datetime_format)}"
  end
  
  def test_not_apply_datetime_format_and_return_raw_value
    # When value is invalid
    formatter = Formatter.new(@format)
    
    assert_same formatter.apply(val = 'invalid value'), val
    assert_same formatter.apply(val = 123456), val
    
    # When format is empty
    format = flexmock(@format, :format_datetime_format => '')
    
    assert_same formatter.apply(@time), @time
  end
end