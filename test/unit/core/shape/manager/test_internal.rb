# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Manager::TestInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def setup
    @init_item_handler = flexmock('init_item_handler')
    
    @format_tblock = flexmock(:type => 's-tblock')
    @format_list   = flexmock(:type => 's-list')
    @format_rect   = flexmock(:type => 's-rect')
    
    @item_tblock   = flexmock(:type => 's-tblock')
    @item_list     = flexmock(:type => 's-list')
    @item_rect     = flexmock(:type => 's-rect')
    
    layout_format = flexmock('layout_format')
    
    layout_format.should_receive(:find_shape).
      with(:tblock).and_return(@format_tblock)
    layout_format.should_receive(:find_shape).
      with(:list).and_return(@format_list)
    layout_format.should_receive(:find_shape).
      with(:rect).and_return(@format_rect)
    layout_format.should_receive(:find_shape).
      with(:unknown).and_return(nil)
    
    @manager = ThinReports::Core::Shape::Manager::Internal.new(layout_format,
                                                               @init_item_handler)
  end
  
  def test_find_format
    assert_same @manager.find_format(:tblock), @format_tblock
    assert_same @manager.find_format('list'), @format_list
    assert_nil  @manager.find_format(:unknown)
  end
  
  def test_valid_type?
    # Without limit options.
    assert_equal @manager.valid_type?('s-list'), true
    # With only limitation.
    assert_equal @manager.valid_type?('s-list', :only => 's-list'), true
    assert_equal @manager.valid_type?('s-list', :only => 'other'), false
    # With except limitation.
    assert_equal @manager.valid_type?('s-list', :except => 'other'), true
    assert_equal @manager.valid_type?('s-list', :except => 's-list'), false
  end
  
  def test_find_item
    flexmock(@init_item_handler).
      should_receive(:call).once.and_return(@item_tblock)
    
    # Should initialize item.
    @manager.find_item(:tblock)
    # Should be stored a one initialized item.
    assert_equal @manager.shapes.size, 1
    assert_same @manager.shapes[:tblock], @item_tblock
    
    flexmock(@init_item_handler).
      should_receive(:call).times(0)
    
    # Should must not be initialized when given a initialized item.
    assert_same @manager.find_item(:tblock), @item_tblock
    
    # Should returnes the nil value when given unknown item.
    assert_nil @manager.find_item(:unknown)
  end
  
  def test_find_item_with_limitation
    # Should returns the nil value when outside limitation.
    assert_nil @manager.find_item(:tblock, :only => 's-list')
    assert_nil @manager.find_item(:list, :except => 's-list')
    
    flexmock(@init_item_handler).
      should_receive(:call).and_return(@item_tblock)
    
    # Should initialize and store item.
    @manager.find_item(:tblock, :except => 's-list')
    assert_equal @manager.shapes[:tblock], @item_tblock
    
    # Should returns the nil value.
    assert_nil @manager.find_item(:tblock, :only => 's-list')
  end
  
  def test_final_shape_when_give_the_initialized_item_that_visibility_is_enabled
    @manager.shapes[:tblock] = flexmock(:visible? => true)
    
    assert_same @manager.final_shape(:tblock), @manager.shapes[:tblock]
  end
  
  def test_final_shape_when_give_the_initialized_item_that_visibility_is_disabled
    @manager.shapes[:tblock] = flexmock(:visible? => false)
    
    assert_nil @manager.final_shape(:tblock)
  end
  
  def test_final_shape_when_give_the_uninitialized_basic_item
    flexmock(@format_rect, :display? => true)
    
    flexmock(@init_item_handler).
      should_receive(:call).once.and_return(@item_rect)
    
    # Should initialize item.
    assert_same @manager.final_shape(:rect), @item_rect
  end
  
  def test_final_shape_return_nil_when_give_the_tblock_item_that_has_no_value
    flexmock(@format_tblock, :display? => true,
                             :has_reference? => false,
                             :value => '')
    assert_nil @manager.final_shape(:tblock)
  end
  
  def test_final_shape_initialize_item_when_give_the_tblock_item_that_has_an_reference
    flexmock(@format_tblock, :display? => true,
                             :has_reference? => true,
                             :value => '')
    
    flexmock(@init_item_handler).
      should_receive(:call).once.and_return(@item_tblock)
    
    assert_same @manager.final_shape(:tblock), @item_tblock
  end
  
  def test_final_shape_initialize_item_when_give_the_tblock_item_that_has_a_value
    flexmock(@format_tblock, :display? => true,
                             :has_reference? => false,
                             :value => 'value')
    
    flexmock(@init_item_handler).
      should_receive(:call).once.and_return(@item_tblock)
    
    assert_same @manager.final_shape(:tblock), @item_tblock    
  end
end