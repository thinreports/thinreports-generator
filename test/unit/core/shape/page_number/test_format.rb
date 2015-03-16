# coding: utf-8

require 'test_helper'

class Thinreports::Core::Shape::PageNumber::TestFormat < Minitest::Test
  include Thinreports::TestHelper

  TEST_PAGENO_FORMAT = {
    "type" => "s-pageno", 
    "id" => "", 
    "display" => "true", 
    "box" => {
      "x" => 100.0, 
      "y" => 100.0, 
      "width" => 100.0, 
      "height" => 100.0
    },
    "format" => "{page} / {total}",
    "overflow" => "truncate", 
    "target" => "",
    "svg" => {
      "tag" => "text",
      "attrs" => {
        "x" => 308.2,
        "y" => 239,
        "kerning" => "auto",
        "id" => "goog_939685354",
        "fill" => "#000000",
        "fill-opacity" => "1",
        "font-size" => "18",
        "font-family" => "Helvetica",
        "font-weight" => "normal",
        "font-style" => "normal",
        "text-anchor" => "middle",
        "text-decoration" => "none"
      }
    }
  }

  Format = Thinreports::Core::Shape::PageNumber::Format

  def format(raw_format = nil)
    Format.new(raw_format || TEST_PAGENO_FORMAT)
  end

  def test_build
    Format.build(TEST_PAGENO_FORMAT)
  rescue => e
    flunk exception_details(e, 'Failed to build')
  end

  def test_id
    pageno = format('id' => 'pageno_id')
    assert_equal pageno.id, 'pageno_id'

    pageno = format('id' => '')
    assert_equal pageno.id, '__pageno1'
    assert_same pageno.id, pageno.id
  end

  def test_overflow
    assert_equal format.overflow, 'truncate'
  end

  def test_target
    assert_equal format.target, ''
    assert_equal format("target" => "list-id").target, 'list-id'
  end

  def test_default_format
    assert_equal format.default_format, '{page} / {total}'
  end
end
