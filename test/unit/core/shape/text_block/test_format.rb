# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::TextBlock::TestFormat < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers

  TEST_TBLOCK_FORMAT = {
    "type" => "s-tblock",
    "id" => "block_1", 
    "display" => "true", 
    "multiple" => "false",
    "overflow" => "truncate",
    "box" => {
      "x" => 100.0,
      "y" => 100.0,
      "width" => 100.0,
      "height" => 100.0
    },
    "format" => {
      "base" => "￥{value}", 
      "type" => "number", 
      "number" => {
        "delimiter" => ",", 
        "precision" => 1
      }
    }, 
    "value" => "", 
    "ref-id" => "", 
    "svg" => {
      "tag" => "text", 
      "attrs" => {
        "x" => 200.1, 
        "y" => 65.6, 
        "text-anchor" => "end", 
        "xml:space" => "preserve", 
        "fill" => "#000000", 
        "fill-opacity" => "1", 
        "font-size" => "12", 
        "font-family" => "\uFF2D\uFF33 \u30B4\u30B7\u30C3\u30AF", 
        "font-weight" => "bold", 
        "font-style" => "normal", 
        "text-decoration" => "none", 
        "clip-path" => "url(#_svgdef_0)"
      }
    }
  }

  def test_build
    build_format
  rescue => e
    flunk exception_details(e, 'Building failed.')
  end
  
  def test_value_reader_via_TEST_TBLOCK_FORMAT
    assert_equal format(TEST_TBLOCK_FORMAT).value, ''
  end
  
  def test_ref_id_reader_via_TEST_TBLOCK_FORMAT
    assert_equal format(TEST_TBLOCK_FORMAT).ref_id, ''
  end
  
  def test_format_base_reader_via_TEST_TBLOCK_FORMAT
    assert_equal format(TEST_TBLOCK_FORMAT).format_base, '￥{value}'
  end
  
  def test_format_type_reader_via_TEST_TBLOCK_FORMAT
    assert_equal format(TEST_TBLOCK_FORMAT).format_type, 'number'
  end
  
  def test_box_reader_via_TEST_TBLOCK_FORMAT
    assert_equal format(TEST_TBLOCK_FORMAT).box.values_at('x', 'y', 'width', 'height'),
                 [100.0, 100.0, 100.0, 100.0]
  end
  
  def test_format_datetime_format_reader_via_TEST_TBLOCK_FORMAT
    assert_nil format(TEST_TBLOCK_FORMAT).format_datetime_format
  end
  
  def test_format_padding_char_reader_via_TEST_TBLOCK_FORMAT
    assert_nil format(TEST_TBLOCK_FORMAT).format_padding_char
  end
  
  def test_format_padding_dir_reader_via_TEST_TBLOCK_FORMAT
    assert_nil format(TEST_TBLOCK_FORMAT).format_padding_dir
  end
  
  def test_format_padding_length_via_TEST_TBLOCK_FORMAT
    assert_equal format(TEST_TBLOCK_FORMAT).format_padding_length, 0
  end
  
  def test_format_padding_rdir_checker_via_TEST_TBLOCK_FORMAT
    assert_equal format(TEST_TBLOCK_FORMAT).format_padding_rdir?, false
  end
  
  def test_format_has_format_asker_via_TEST_TBLOCK_FORMAT
    assert_equal format(TEST_TBLOCK_FORMAT).has_format?, true
  end
  
  def test_format_has_reference_asker_via_TEST_TBLOCK_FORMAT
    assert_equal format(TEST_TBLOCK_FORMAT).has_reference?, false
  end
  
  def test_format_multiple_checker_via_TEST_TBLOCK_FORMAT
    assert_equal format(TEST_TBLOCK_FORMAT).multiple?, false
  end
  
  def test_overflow_via_TEST_TBLOCK_FORMAT
    assert_equal format(TEST_TBLOCK_FORMAT).overflow, 'truncate'
  end
  
  def test_multiple_checker_should_return_true
    assert format('multiple' => 'true').multiple?
  end
  
  def test_multiple_checker_should_return_false
    refute format('multiple' => 'false').multiple?
  end
  
  def test_format_padding_rdir_checker_should_return_false
    data = {'format' => {'padding' => {'direction' => 'L'}}}
    refute format(data).format_padding_rdir?
  end
  
  def test_format_padding_rdir_checker_should_return_true
    data = {'format' => {'padding' => {'direction' => 'R'}}}
    assert format(data).format_padding_rdir?
  end
  
  def test_format_padding_length_should_return_Numeric
    data = {'format' => {'padding' => {'length' => '999'}}}
    assert_kind_of ::Numeric, format(data).format_padding_length
  end

  def test_has_format_asker_should_return_false_with_empty_value
    data = {'format' => {'type' => ''}}
    refute format(data).has_format?
  end
  
  def test_has_format_asker_should_return_false_with_unknown_type
    data = {'format' => {'type' => 'unknown'}}
    refute format(data).has_format?
  end
  
  def test_has_format_asker_should_return_true
    data = {'format' => {'type' => 'number'}}
    assert format(data).has_format?
  end
  
  def test_has_reference_asker_should_return_false
    refute format('ref-id' => '').has_reference?
  end
  
  def test_has_reference_asker_should_return_true
    assert format('ref-id' => 'ref_tblock_1').has_reference?
  end
  
  def build_format
    ThinReports::Core::Shape::TextBlock::Format.build(TEST_TBLOCK_FORMAT)
  end
  
  def format(data)
    ThinReports::Core::Shape::TextBlock::Format.new(data)
  end
end
