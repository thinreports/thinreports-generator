# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Text::TestInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  Text = ThinReports::Core::Shape::Text
  
  def setup
    format = flexmock('format')
    format.should_receive(:type => 's-text')
    
    @internal = Text::Internal.new(flexmock('parent'), format)
  end
  
  def test_type_of?
    assert_equal @internal.type_of?(:text), true
    assert_equal @internal.type_of?(:basic), false
  end
end