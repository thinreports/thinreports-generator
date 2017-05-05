# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Manager::TestInternal < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  Shape = Thinreports::Core::Shape

  def create_shape_format(type, id, other_config = {})
    Shape::Format(type).new({'id' => id,
                             'type' => type,
                             'display' => true}.merge(other_config))
  end

  def create_internal(&block)
    report = Thinreports::Report.new layout: layout_file.path
    format = report.layout.format

    block.call(format) if block_given?

    report.start_new_page.manager
  end

  def test_find_format_should_return_format_with_the_specified_Symbol_id
    assert_equal create_internal.find_format(:text_block).id, 'text_block'
  end

  def test_find_format_should_return_format_with_the_specified_String_id
    assert_equal create_internal.find_format('text_block').id, 'text_block'
  end

  def test_find_format_should_return_nil_when_format_with_specified_id_is_not_found
    assert_nil create_internal.find_format(:unknown)
  end

  def test_find_item_should_return_shape_with_the_specified_id
    assert_instance_of Shape::TextBlock::Interface, create_internal.find_item(:text_block)
  end

  def test_find_item_should_return_shape_in_shapes_registry_when_the_specified_shape_exists_in_registry
    internal = create_internal
    internal.find_item(:text_block)

    assert_same internal.find_item(:text_block), internal.shapes[:text_block]
  end

  def test_find_item_should_return_shape_when_passing_in_the_specified_only_filter
    internal = create_internal
    assert_equal internal.find_item(:text_block, only: 'text-block').id, 'text_block'
  end

  def test_find_item_should_return_nil_when_not_passing_in_the_specified_only_filter
    internal = create_internal
    assert_nil internal.find_item(:text_block, only: 'list')
  end

  def test_find_item_should_return_shape_when_passing_in_the_specified_except_filter
    internal = create_internal
    assert_equal internal.find_item(:default, except: 'text-block').id, 'default'
  end

  def test_find_item_should_return_shape_when_not_passing_in_the_specified_except_filter
    internal = create_internal
    assert_nil internal.find_item(:default, except: 'list')
  end

  def test_final_shape_should_return_nil_when_shape_is_not_found
    internal = create_internal
    assert_nil internal.final_shape(:unknown)
  end

  def test_final_shape_should_return_nil_when_shape_is_stored_in_shapes_and_hidden
    internal = create_internal
    internal.find_item(:text_block).hide

    assert_nil internal.final_shape(:text_block)
  end

  def test_final_shape_should_return_shape_when_shape_is_stored_in_shapes_and_TextBlock_with_value
    internal = create_internal
    internal.find_item(:text_block).value('value')

    assert_equal internal.final_shape(:text_block).id, 'text_block'
  end

  def test_final_shape_should_return_nil_when_shape_is_stored_in_shapes_and_TextBlock_with_no_value
    internal = create_internal
    internal.find_item(:text_block)

    assert_nil internal.final_shape(:text_block)
  end

  def test_final_shape_should_return_shape_when_shape_is_stored_in_shapes_and_ImageBlock_with_src
    internal = create_internal
    internal.find_item(:image_block).src('/path/to/image.png')

    assert_equal internal.final_shape(:image_block).id, 'image_block'
  end

  def test_final_shape_should_return_nil_when_shape_is_stored_in_shapes_and_ImageBlock_with_no_src
    internal = create_internal
    assert_nil internal.final_shape(:image_block)
  end

  def test_final_shape_should_return_nil_when_shape_isnot_stored_in_shapes_and_hidden
    assert_nil create_internal.final_shape(:text_block_hidden)
  end

  def test_final_shape_should_return_shape_when_shape_isnot_stored_in_shapes_and_not_Block
    assert_equal create_internal.final_shape(:rect_with_id).id, 'rect_with_id'
  end

  def test_final_shape_should_return_nil_when_shape_isnot_stored_in_shapes_and_ImageBlock
    internal = create_internal do |f|
      f.shapes[:iblock] = create_shape_format('image-block', 'iblock')
    end

    assert_nil internal.final_shape(:iblock)
  end

  def test_final_shape_should_return_shape_when_shape_isnot_stored_in_shapes_and_TextBlock_with_reference
    assert_equal create_internal.final_shape(:text_block_referenced).id, 'text_block_referenced'
  end

  def test_final_shape_should_return_nil_when_shape_isnot_stored_in_shapes_and_TextBlock_with_no_value_no_reference
    internal = create_internal

    assert_nil internal.final_shape(:t1)
  end
end
