# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Basic::TestInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  Basic = ThinReports::Core::Shape::Basic
  
  def setup
    format = flexmock('format')
    format.should_receive(:display? => true)
    
    @internal = Basic::Internal.new(flexmock('parent'), format)
  end
  
  def test_visible
    assert_equal @internal.visible?, true
    
    @internal.visible(false)
    
    assert_equal @internal.visible?, false
    assert_equal @internal.format.display?, true
  end
  
  def test_svg_attr
    assert_empty @internal.attrs
    
    @internal.svg_attr(:fill, 'red')
    @internal.svg_attr(:stroke, 'black')
    
    assert_equal @internal.attrs, {'fill' => 'red', 'stroke' => 'black'}
  end
  
  def test_type_of?
    flexmock(@internal.format).should_receive(:type => 's-rect')
    
    assert_equal @internal.type_of?(:basic), true
    assert_equal @internal.type_of?(:rect), true
    assert_equal @internal.type_of?(:tblock), false
  end
end