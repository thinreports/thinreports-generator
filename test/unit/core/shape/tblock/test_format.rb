# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Tblock::TestFormat < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers

  TEST_TBLOCK_FORMAT = {
    "type" => "s-tblock",
    "id" => "block_1", 
    "display" => "true", 
    "multiple" => "false",
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
  rescue
    flunk exception_details(e, 'Building failed.')
  end
  
  def test_config_readers
    format = format(TEST_TBLOCK_FORMAT)
    
    assert_equal format.value, ''
    assert_equal format.ref_id, ''
    assert_equal format.format_base, '￥{value}'
    assert_equal format.format_type, 'number'
    assert_instance_of ::Hash, format.box
    assert_equal format.box['x'], 100.0
    
    # Methods reference to unknown value returns a nil value
    assert_nil format.format_datetime_format
    assert_nil format.format_padding_char
    assert_nil format.format_padding_dir
    
    # In face, #format_padding_length returns a nil value
    assert_equal format.format_padding_length, 0

    assert_equal format.format_padding_rdir?, false
    assert_equal format.has_format?, true
    assert_equal format.has_reference?, false
    assert_equal format.multiple?, false
  end
  
  def test_multiple?
    assert format('multiple' => 'true').multiple?
    refute format('multiple' => 'false').multiple?
  end
  
  def test_format_padding_rdir?
    data = {'format' => {'padding' => {'direction' => 'L'}}}
    
    refute format(data).format_padding_rdir?
    
    data['format']['padding']['direction'] = 'R'
    assert format(data).format_padding_rdir?
  end
  
  def test_format_padding_length
    data = {'format' => {'padding' => {'length' => '0'}}}
    
    assert_equal format(data).format_padding_length, 0
    
    data['format']['padding']['length'] = '10'
    assert_equal format(data).format_padding_length, 10
  end
  
  def test_has_format?
    data = {'format' => {'type' => ''}}
    
    refute format(data).has_format?
    
    data['format']['type'] = 'number'
    assert format(data).has_format?
    
    data['format']['type'] = 'unknown'
    refute format(data).has_format?
  end
  
  def test_has_reference?
    refute format('ref-id' => '').has_reference?
    assert format('ref-id' => 'ref_tblock_1').has_reference?
  end
  
  def build_format
    ThinReports::Core::Shape::Tblock::Format.build(TEST_TBLOCK_FORMAT)
  end
  
  def format(data)
    ThinReports::Core::Shape::Tblock::Format.new(data)
  end
end