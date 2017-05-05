# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Text::TestFormat < Minitest::Test
  include Thinreports::TestHelper

  TEXT_FORMAT = {
    'id' => 'text_1',
    'type' => 'text',
    'x' => 100.0,
    'y' => 200.0,
    'width' => 300.0,
    'height' => 400.0,
    'description' => 'Description for item',
    'display' => true,
    'texts' => [
      '1st text line',
      '2nd text line'
    ],
    'valign' => 'top',
    'style' => {
      'font-family' => ['Arial'],
      'font-size' => 12,
      'color' => '#000000',
      'font-style' => ['bold', 'italic', 'linethrough', 'underline'],
      'text-align' => 'left',
      'vertical-align' => 'top',
      'line-height' => 60,
      'line-height-ratio' => 1.5,
      'letter-spacing' => 'normal'
    }
  }

  Text = Thinreports::Core::Shape::Text

  def test_attribute_readers
    format = Text::Format.new(TEXT_FORMAT)

    assert_equal TEXT_FORMAT['texts'], format.texts
    assert_equal 'top', format.valign
    assert_equal 60, format.line_height
  end
end
