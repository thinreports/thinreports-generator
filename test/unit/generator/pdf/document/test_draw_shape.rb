# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::PDF::TestDrawShape < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers

  def setup
    @pdf = ThinReports::Generator::PDF::Document.new
  end

  def create_tblock_interface(format_config = {})
    format = ThinReports::Core::Shape::TextBlock::Format.new(format_config)
    ThinReports::Core::Shape::TextBlock::Interface.new(flexmock('parent'), format)
  end

  def test_shape_text_attrs_should_return_attrs_containing_an_overflow_property
    tblock = create_tblock_interface('id' => 'text', 'overflow' => 'truncate')
    assert_equal @pdf.send(:shape_text_attrs, tblock.internal)[:overflow], :truncate
  end

  def test_shape_text_attrs_should_return_attrs_containing_an_valign_property
    tblock = create_tblock_interface('id' => 'text', 'valign' => 'top')
    assert_equal @pdf.send(:shape_text_attrs, tblock.internal)[:valign], :top
  end

  def test_shape_text_attrs_should_return_attrs_containing_an_line_height_unless_line_height_is_blank
    tblock = create_tblock_interface('id' => 'text', 'line-height' => '10')
    assert_equal @pdf.send(:shape_text_attrs, tblock.internal)[:line_height], '10'
  end

  def test_shape_text_attrs_should_return_attrs_uncontaining_an_line_height_if_line_height_is_blank
    tblock = create_tblock_interface('id' => 'text', 'line-height' => '')
    assert_nil @pdf.send(:shape_text_attrs, tblock.internal)[:line_height]
  end
end
