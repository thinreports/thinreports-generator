# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Manager::TestTarget < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Shape = ThinReports::Core::Shape
  
  class TestManager
    include Shape::Manager::Target
    
    attr_reader :layout, :report
    
    def initialize(report, layout)
      @report = report
      @layout = layout
      
      initialize_manager(layout.format) do |f|
        Shape::Interface(self, f)
      end
    end
  end
  
  def create_shape_format(type, id)
    Shape::Format(type).new('id' => id, 'type' => type)
  end
  
  def create_manager
    report = create_basic_report('basic_layout1.tlf')
    layout = report.layout
    
    # Add to dummy shapes.
    layout.format.shapes[:t1] = create_shape_format('s-tblock', 't1')
    layout.format.shapes[:t2] = create_shape_format('s-tblock', 't2')
    layout.format.shapes[:ls] = create_shape_format('s-list', 'ls')
    layout.format.shapes[:default] = create_shape_format('s-list', 'default')
    
    TestManager.new(report, layout)
  end
  
  def test_manager_should_return_instance_of_ManagerInternal
    assert_instance_of Shape::Manager::Internal, create_manager.manager
  end
  
  def test_item_should_properly_return_shape_with_the_specified_Symbol_id
    assert_equal create_manager.item(:t1).id, 't1'
  end
  
  def test_item_should_properly_return_shape_with_the_specified_String_id
    assert_equal create_manager.item('t2').id, 't2'
  end
  
  def test_item_should_raise_when_the_shape_with_the_specified_id_is_not_found
    assert_raises ThinReports::Errors::UnknownItemId do
      create_manager.item(:unknown)
    end
  end
  
  def test_item_should_set_an_shape_as_argument_when_a_block_is_given
    id = nil
    create_manager.item(:t1) {|s| id = s.id }
    assert_equal id, 't1'
  end
  
  def test_item_should_raise_when_type_of_shape_with_the_specified_id_is_list
    assert_raises ThinReports::Errors::UnknownItemId do
      create_manager.item(:ls)
    end
  end
  
  def test_list_should_properly_return_list_with_the_specified_Symbol_id
    assert_equal create_manager.list(:ls).id, 'ls'
  end
  
  def test_list_should_properly_return_list_with_the_specified_String_id
    assert_equal create_manager.list('ls').id, 'ls'
  end
  
  def test_list_should_raise_when_type_of_shape_with_the_specified_id_is_not_list
    assert_raises ThinReports::Errors::UnknownItemId do
      create_manager.list(:t1)
    end
  end
  
  def test_list_should_use_default_as_id_when_id_is_omitted
    assert_equal create_manager.list.id, 'default'
  end
  
  def test_values_should_properly_set_values_to_shapes_with_specified_id
    manager = create_manager
    manager.values(:t1 => 1000, 't2' => 'value')
    
    assert_equal [manager.item(:t1).value, manager.item(:t2).value], [1000, 'value']
  end
  
  def test_items_should_show_deprecation_warning
    out, err = capture_io do
      create_manager.items(:t1 => 1000)
    end
    assert_match %r!DEPRECATION!, err
  end
  
  def test_item_exists_asker_should_return_true_when_shape_with_specified_Symbol_id_is_found
    assert_equal create_manager.item_exists?(:t1), true
  end
  
  def test_item_exists_asker_should_return_true_when_shape_with_specified_String_id_is_found
    assert_equal create_manager.item_exists?('t2'), true
  end
  
  def test_item_exists_asker_should_return_false_when_shape_with_specified_id_not_found
    assert_equal create_manager.item_exists?('unknown'), false
  end
  
  def test_exists_asker_should_operate_like_as_item_exists_asker
    manager = create_manager
    assert_equal manager.exists?(:unknown), manager.item_exists?(:unknown)
  end
end