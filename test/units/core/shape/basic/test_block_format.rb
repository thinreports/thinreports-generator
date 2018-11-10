# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Basic::TestBlockFormat < Minitest::Test
  include Thinreports::TestHelper

  BLOCK_FORMAT = {
    'value' => 'default value',
    'x' => 100.0,
    'y' => 200.0,
    'width' => 300.0,
    'height' => 400.0
  }

  Basic = Thinreports::Core::Shape::Basic

  def test_attribute_readers
    format = Basic::BlockFormat.new(BLOCK_FORMAT)

    assert_equal 'default value', format.value
  end
end
