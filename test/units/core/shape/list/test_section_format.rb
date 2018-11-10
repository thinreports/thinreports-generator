# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::List::TestSectionFormat < Minitest::Test
  include Thinreports::TestHelper

  LIST_SECTION_FORMAT = {
    'enabled' => true,
    'height' => 47.7,
    'translate' => { 'x' => 0, 'y' => -64.2 },
    'items' => [
      { 'type' => 'rect', 'id' => '' },
      { 'type' => 'text-block', 'id' => 'text_block' }
    ]
  }

  Shape = Thinreports::Core::Shape
  List = Thinreports::Core::Shape::List

  def test_attribute_readers
    format = List::SectionFormat.new(LIST_SECTION_FORMAT)

    assert_equal 47.7, format.height
    assert_equal 0, format.relative_left
    assert_equal(-64.2, format.relative_top)
    assert_equal true, format.display?
  end

  def test_initialize_items
    format = List::SectionFormat.new(LIST_SECTION_FORMAT)

    assert_equal 1, format.shapes.count
    assert_instance_of Shape::TextBlock::Format, format.shapes[:text_block]
  end
end
