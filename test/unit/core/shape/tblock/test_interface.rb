# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Tblock::TestInterface < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  Tblock = ThinReports::Core::Shape::Tblock
  
  def setup
    @interface = Tblock::Interface.new(flexmock('parent'), flexmock('format'))
  end
  
  def test_value_work_as_getter_when_receive_no_arguments
    flexmock(@interface.internal).should_receive(:read_value).
        and_return('value').once
    
    assert_equal @interface.value, 'value'
  end
  
  def test_value_work_as_setter_when_receive_an_just_one_argument
    flexmock(@interface.internal).should_receive(:write_value).once
    
    @interface.value('any value')
  end
  
  def test_value_raise_error_when_receive_more_than_two
    assert_raises ArgumentError do
      @interface.value('arg1', 'arg2')
    end
  end
  
  def test_set
    flexmock(@interface).
        should_receive(:value).once.
        should_receive(:styles).once
    
    @interface.set('value', :fill => 'red')
  end
end