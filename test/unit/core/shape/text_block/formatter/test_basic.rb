# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::TextBlock::Formatter::TestBasic < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Formatter = ThinReports::Core::Shape::TextBlock::Formatter::Basic
  
  def test_apply_simple_format
    format = flexmock(:format_base => 'Hello {value}!')
    
    assert_equal Formatter.new(format).apply('ThinReports'),
                 'Hello ThinReports!'
  end
  
  def test_apply_multiple_format
    format = flexmock(:format_base => 'Hello {value}! And good bye {value}.')
    
    assert_equal Formatter.new(format).apply('ThinReports'),
                 'Hello ThinReports! And good bye ThinReports.'
  end
end