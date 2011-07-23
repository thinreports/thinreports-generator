# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::List::TestPageState < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  List = ThinReports::Core::Shape::List
  
  def setup
    parent = flexmock('parent')
    format = flexmock('format')
    
    @state = List::PageState.new(parent, format)
  end
  
  def test_alias_class
    assert_same List::PageState, List::Internal
  end
  
  def test_type_of?
    assert_equal @state.type_of?(:list), true
  end
  
  def test_finalized!
    assert_equal @state.finalized?, false
    @state.finalized!
    assert_equal @state.finalized?, true
  end
end