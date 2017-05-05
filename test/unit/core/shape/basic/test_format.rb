# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Basic::TestFormat < Minitest::Test
  include Thinreports::TestHelper

  RECT_FORMAT = {
    "id" => "",
    "type" => "rect",
    "x" => 100.0,
    "y" => 200.0,
    "width" => 300.0,
    "height" => 400.0,
    "description" => "Description for rect",
    "display" => true,
    "rx" => 1.0,
    "ry" => 1.0,
    "style" => {
      "border-width" => 1,
      "border-color" => "#000000",
      "border-style" => "dashed",
      "fill-color" => "#ff0000"
    }
  }

  Basic = Thinreports::Core::Shape::Basic

  def test_attribute_readers
    format = Basic::Format.new(RECT_FORMAT)

    assert_equal '', format.id
    assert_equal 'rect', format.type
    assert_equal RECT_FORMAT['style'], format.style
    assert_equal true, format.display?
  end
end
