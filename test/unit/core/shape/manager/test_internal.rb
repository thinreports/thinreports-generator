# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Manager::TestInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Shape = ThinReports::Core::Shape
  
  def create_shape_format(type, id, other_config = {})
    Shape::Format(type).new({'id'      => id,
                             'type'    => type,
                             'display' => 'true'}.merge(other_config))
  end
  
  def create_internal(&block)
    report = create_basic_report('basic_layout1.tlf')
    format = report.layout.format
    
    # Add to default dummy shapes.
    format.shapes[:t1] = create_shape_format('s-tblock', 't1', 'value' => '')
    format.shapes[:t2] = create_shape_format('s-tblock', 't2', 'value' => '')
    format.shapes[:ls] = create_shape_format('s-list', 'ls')
    
    block.call(format) if block_given?
    
    report.start_new_page.manager
  end
  
  def test_find_format_should_return_format_with_the_specified_Symbol_id
    assert_equal create_internal.find_format(:t1).id, 't1'
  end
  
  def test_find_format_should_return_format_with_the_specified_String_id
    assert_equal create_internal.find_format('t2').id, 't2'
  end
  
  def test_find_format_should_return_nil_when_format_with_specified_id_is_not_found
    assert_nil create_internal.find_format(:unknown)
  end
  
  def test_find_item_should_return_shape_with_the_specified_id
    assert_instance_of Shape::TextBlock::Interface, create_internal.find_item(:t1)
  end
  
  def test_find_item_should_return_shape_in_shapes_registry_when_the_specified_shape_exists_in_registry
    internal = create_internal
    internal.find_item(:t1)
    
    assert_same internal.find_item(:t1), internal.shapes[:t1]
  end
  
  def test_find_item_should_return_shape_when_passing_in_the_specified_only_filter
    internal = create_internal
    assert_equal internal.find_item(:t1, :only => 's-tblock').id, 't1'
  end
  
  def test_find_item_should_return_nil_when_not_passing_in_the_specified_only_filter
    internal = create_internal
    assert_nil internal.find_item(:t1, :only => 's-list')
  end
  
  def test_find_item_should_return_shape_when_passing_in_the_specified_except_filter
    internal = create_internal
    assert_equal internal.find_item(:ls, :except => 's-tblock').id, 'ls'
  end
  
  def test_find_item_should_return_shape_when_not_passing_in_the_specified_except_filter
    internal = create_internal
    assert_nil internal.find_item(:ls, :except => 's-list')
  end
  
  def test_final_shape_should_return_nil_when_shape_is_not_found
    internal = create_internal
    assert_nil internal.final_shape(:unknown)
  end
  
  def test_final_shape_should_return_nil_when_shape_is_stored_in_shapes_and_hidden
    internal = create_internal
    internal.find_item(:t1).hide
    
    assert_nil internal.final_shape(:t1)
  end
  
  def test_final_shape_should_return_shape_when_shape_is_stored_in_shapes_and_not_Block
    internal = create_internal do |f|
      f.shapes[:rect] = create_shape_format('s-rect', 'rect')
    end
    internal.find_item(:rect)
    
    assert_equal internal.final_shape(:rect).id, 'rect'
  end
  
  def test_final_shape_should_return_shape_when_shape_is_stored_in_shapes_and_TextBlock_with_value
    internal = create_internal
    internal.find_item(:t1).value('value')
    
    assert_equal internal.final_shape(:t1).id, 't1'
  end
  
  def test_final_shape_should_return_nil_when_shape_is_stored_in_shapes_and_TextBlock_with_no_value
    internal = create_internal
    internal.find_item(:t2)
    
    assert_nil internal.final_shape(:t2)
  end
  
  def test_final_shape_should_return_shape_when_shape_is_stored_in_shapes_and_ImageBlock_with_src
    internal = create_internal do |f|
      f.shapes[:iblock] = create_shape_format('s-iblock', 'iblock')
    end
    internal.find_item(:iblock).src('/path/to/image.png')
    
    assert_equal internal.final_shape(:iblock).id, 'iblock'
  end
  
  def test_final_shape_should_return_nil_when_shape_is_stored_in_shapes_and_ImageBlock_with_no_src
    internal = create_internal do |f|
      f.shapes[:iblock] = create_shape_format('s-iblock', 'iblock')
    end
    
    assert_nil internal.final_shape(:iblock)
  end
  
  def test_final_shape_should_return_nil_when_shape_isnot_stored_in_shapes_and_hidden
    internal = create_internal do |f|
      f.shapes[:t3] = create_shape_format('s-tblock', 't3', 'display' => 'false')
    end
    
    assert_nil internal.final_shape(:t3)
  end
  
  def test_final_shape_should_return_shape_when_shape_isnot_stored_in_shapes_and_not_Block
    internal = create_internal do |f|
      f.shapes[:rect] = create_shape_format('s-rect', 'rect')
    end
    
    assert_equal internal.final_shape(:rect).id, 'rect'
  end
  
  def test_final_shape_should_return_nil_when_shape_isnot_stored_in_shapes_and_ImageBlock
    internal = create_internal do |f|
      f.shapes[:iblock] = create_shape_format('s-iblock', 'iblock')
    end
    
    assert_nil internal.final_shape(:iblock)
  end
  
  def test_final_shape_should_return_shape_when_shape_isnot_stored_in_shapes_and_TextBlock_with_value
    internal = create_internal do |f|
      f.shapes[:t3] = create_shape_format('s-tblock', 't3', 'value' => 'default value')
    end
    
    assert_equal internal.final_shape(:t3).id, 't3'
  end
  
  def test_final_shape_should_return_shape_when_shape_isnot_stored_in_shapes_and_TextBlock_with_reference
    internal = create_internal do |f|
      f.shapes[:t3] = create_shape_format('s-tblock', 't3', 'ref-id' => 't1')
    end
    
    assert_equal internal.final_shape(:t3).id, 't3'
  end
  
  def test_final_shape_should_return_nil_when_shape_isnot_stored_in_shapes_and_TextBlock_with_no_value_no_reference
    internal = create_internal
    
    assert_nil internal.final_shape(:t1)
  end
end