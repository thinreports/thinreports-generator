# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Text::TestFormat < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers

  TEST_TEXT_FORMAT = {
    "type" => "s-text",
    "id" => "text_1",
    "display" => "true",
    "text" => ["Text Content1", "Text Content2"],
    "valign" => "top",
    "line-height" => 60,
    "box" => {
      "x" => 100.0,
      "y" => 100.0,
      "width" => 100.0,
      "height" => 100.0
    },
    "svg" => {
      "tag" => "g",
      "attrs" => {
        "stroke-width" => "0",
        "font-weight" => "normal",
        "font-style" => "normal",
        "font-family" => "Arial",
        "font-size" => "12",
        "text-anchor" => "start",
        "fill" => "#000000",
        "fill-opacity" => "1",
        "text-decoration" => "none",
        "letter-spacing" => "normal"
      },
      "content" => "<text class=\"s-text-l0\" xml:space=\"preserve\" " +
                   "stroke=\"none\" fill=\"inherit\" fill-opacity=\"1\" " +
                   "text-decoration=\"none\" x=\"92\" y=\"93\">" +
                   "Text Content1</text>" +
                   "<text class=\"s-text-l1\" xml:space=\"preserve\" " +
                   "stroke=\"none\" fill=\"inherit\" fill-opacity=\"1\" " +
                   "text-decoration=\"none\" x=\"92\" y=\"107\">" +
                   "Text Content2</text>"
    }
  }

  # Alias
  Format = ThinReports::Core::Shape::Text::Format

  def test_build_format
    build_format
  rescue => e
    flunk exception_details(e, 'Building failed.')
  end
  
  def test_config_readers
    format = Format.new(TEST_TEXT_FORMAT)
    
    assert_instance_of ::Hash, format.box
    assert_equal format.box['x'], 100.0
    
    assert_instance_of ::Array, format.text
    assert_equal format.text.first, 'Text Content1'
    
    assert_equal format.valign, 'top'
    assert_equal format.line_height, 60
    
    assert_equal format.svg_content, TEST_TEXT_FORMAT['svg']['content']
  end
  
  def build_format
    Format.build(TEST_TEXT_FORMAT)
  end
end