# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Style::TestBasic < Minitest::Test
  include Thinreports::TestHelper

  def create_basic_style(format_config = {})
    format = Thinreports::Core::Shape::Basic::Format.new(format_config)
    Thinreports::Core::Shape::Style::Basic.new(format)
  end

  def test_visible_should_return_visibility_of_format_as_default
    style = create_basic_style('display' => false)
    assert_equal style.visible, false
  end

  def test_visible_should_properly_set_visibility
    style = create_basic_style('display' => false)
    style.visible = true

    assert_equal style.visible, true
  end
end
