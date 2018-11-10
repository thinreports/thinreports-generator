# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Manager::TestTarget < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  Shape = Thinreports::Core::Shape

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
    report = Thinreports::Report.new layout: layout_file.path
    layout = report.layout

    TestManager.new(report, layout)
  end

  def test_shorthand_for_finding_item
    manager = create_manager

    text_block1 = manager[:text_block]
    text_block1.value = 'block1'

    assert_instance_of Shape::TextBlock::Interface, manager[:text_block]
    assert_instance_of Shape::ImageBlock::Interface, manager[:image_block]
    assert_instance_of Shape::Basic::Interface, manager[:rect_with_id]

    assert_raises Thinreports::Errors::UnknownItemId do
      manager[:unknown_id]
    end

    assert_raises Thinreports::Errors::UnknownItemId do
      manager[:default]
    end
  end

  def test_shorthand_for_setting_value_to_block
    manager = create_manager

    manager[:text_block] = 'value of text block1'
    assert_equal 'value of text block1', manager.item(:text_block).value

    manager[:image_block] = '/path/to/image.png'
    assert_equal '/path/to/image.png', manager.item(:image_block).src

    assert_raises(NoMethodError) { manager[:rect_with_id] = 'value' }
    assert_raises(Thinreports::Errors::UnknownItemId) { manager[:default] = 'value' }
  end

  def test_manager_should_return_instance_of_ManagerInternal
    assert_instance_of Shape::Manager::Internal, create_manager.manager
  end

  def test_item_should_properly_return_shape_with_the_specified_Symbol_id
    assert_equal create_manager.item(:text_block).id, 'text_block'
  end

  def test_item_should_properly_return_shape_with_the_specified_String_id
    assert_equal create_manager.item('text_block').id, 'text_block'
  end

  def test_item_should_raise_when_the_shape_with_the_specified_id_is_not_found
    assert_raises Thinreports::Errors::UnknownItemId do
      create_manager.item(:unknown)
    end
  end

  def test_item_should_set_an_shape_as_argument_when_a_block_is_given
    id = nil
    create_manager.item(:text_block) {|s| id = s.id }
    assert_equal id, 'text_block'
  end

  def test_item_should_raise_when_type_of_shape_with_the_specified_id_is_list
    assert_raises Thinreports::Errors::UnknownItemId do
      create_manager.item(:default)
    end
  end

  def test_list_should_properly_return_list_with_the_specified_Symbol_id
    assert_equal create_manager.list(:default).id, 'default'
  end

  def test_list_should_properly_return_list_with_the_specified_String_id
    assert_equal create_manager.list('default').id, 'default'
  end

  def test_list_should_raise_when_type_of_shape_with_the_specified_id_is_not_list
    assert_raises Thinreports::Errors::UnknownItemId do
      create_manager.list(:text_block)
    end
  end

  def test_list_should_use_default_as_id_when_id_is_omitted
    assert_equal create_manager.list.id, 'default'
  end

  def test_values_should_properly_set_values_to_shapes_with_specified_id
    manager = create_manager
    manager.values(text_block: 1000)

    assert_equal manager.item(:text_block).value, 1000
  end

  def test_item_exists_asker_should_return_true_when_shape_with_specified_Symbol_id_is_found
    assert_equal create_manager.item_exists?(:text_block), true
  end

  def test_item_exists_asker_should_return_true_when_shape_with_specified_String_id_is_found
    assert_equal create_manager.item_exists?('text_block'), true
  end

  def test_item_exists_asker_should_return_false_when_shape_with_specified_id_not_found
    assert_equal create_manager.item_exists?('unknown'), false
  end

  def test_exists_asker_should_operate_like_as_item_exists_asker
    manager = create_manager
    assert_equal manager.exists?(:unknown), manager.item_exists?(:unknown)
  end
end
