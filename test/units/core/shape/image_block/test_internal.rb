# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::ImageBlock::TestInternal < Minitest::Test
  include Thinreports::TestHelper

  ImageBlock = Thinreports::Core::Shape::ImageBlock

  def test_src_should_return_the_same_value_as_value_method
    internal = create_internal
    internal.write_value('/path/to/image.png')

    assert_same internal.src, internal.read_value
  end

  def test_type_of_asker_should_return_true_when_iblock_value_is_given
    assert_equal create_internal.type_of?('image-block'), true
  end

  def test_type_of_asker_should_return_true_when_block_value_is_given
    assert_equal create_internal.type_of?(:block), true
  end

  def create_internal
    report = Thinreports::Report.new layout: layout_file.path
    parent = report.start_new_page

    ImageBlock::Internal.new parent, ImageBlock::Format.new({})
  end
end
