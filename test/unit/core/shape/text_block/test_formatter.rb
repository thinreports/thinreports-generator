# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::TextBlock::TestFormatter < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Formatter = ThinReports::Core::Shape::TextBlock::Formatter
  
  def test_initialize_formatter_by_type
    assert_instance_of Formatter::Basic,
      Formatter.setup( flexmock(:format_type => '') )
    
    assert_instance_of Formatter::Number,
      Formatter.setup( flexmock(:format_type => 'number') )
      
    assert_instance_of Formatter::Datetime,
      Formatter.setup( flexmock(:format_type => 'datetime') )
    
    assert_instance_of Formatter::Padding,
      Formatter.setup( flexmock(:format_type => 'padding') )
      
    assert_raises ThinReports::Errors::UnknownFormatterType do
      Formatter.setup( flexmock(:format_type => 'unknown') )
    end
  end
end