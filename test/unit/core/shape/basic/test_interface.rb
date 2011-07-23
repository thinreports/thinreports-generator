# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Basic::TestInterface < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers

  # Alias
  Basic = ThinReports::Core::Shape::Basic
  
  def setup
    format = flexmock('format')
    format.should_receive(:display? => true)
    
    @basic = Basic::Interface.new(flexmock('parent'), format)
  end
  
  def test_visible
    assert_equal @basic.visible?, true
    @basic.visible(false)
    assert_equal @basic.visible?, false
  end
  
  def test_style
    @basic.style(:fill, '#ff0000')
    @basic.style(:stroke, '#0000ff')
    
    assert_equal @basic.internal.attrs, {'fill' => '#ff0000',
                                         'stroke' => '#0000ff'}
    assert_raises ThinReports::Errors::UnknownShapeStyleName do
      @basic.style(:unknown, 'unknown value')
    end
  end
  
  def test_styles
    @basic.styles(:fill => 'red', :stroke => 'blue')
    
    assert_equal @basic.internal.attrs, {'fill' => 'red',
                                         'stroke' => 'blue'}
    assert_raises ThinReports::Errors::UnknownShapeStyleName do
      @basic.styles(:fill => 'blue', :unknown => 'black')
    end
  end
  
  def test_hide
    @basic.hide
    assert_equal @basic.visible?, false
  end
  
  def test_show
    @basic.visible(false)
    @basic.show
    assert_equal @basic.visible?, true
  end
  
  def test_method_chain
    @basic.hide.show
    assert_equal @basic.visible?, true
    
    @basic.style(:fill, 'red').hide
    assert_equal @basic.internal.attrs['fill'], 'red'
    assert_equal @basic.visible?, false
    
    @basic.styles(:fill => 'red', :stroke => 'blue').style(:fill, 'black')
    assert_equal @basic.internal.attrs['fill'], 'black'
    
    @basic.visible(true).visible(false)
    assert_equal @basic.visible?, false
  end
end