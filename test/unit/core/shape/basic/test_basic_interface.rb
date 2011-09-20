# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Basic::TestBlockInterface < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  Basic = ThinReports::Core::Shape::Basic
  
  def setup
    parent = flexmock('parent')
    format = Basic::BlockFormat.new({})
    internal = Basic::BlockInternal.new(parent, Basic::BlockFormat.new({}))
    
    @interface = Basic::BlockInterface.new(parent, format, internal)
  end
  
  def test_value_should_work_as_reader_with_no_arguments
    @interface.internal.write_value('new value')
    assert_equal @interface.value, 'new value'
  end
  
  def test_value_should_work_as_writer_with_arguments
    @interface.value('new value')
    assert_equal @interface.internal.read_value, 'new value'
  end
end