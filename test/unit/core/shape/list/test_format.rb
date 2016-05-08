# coding: utf-8

require 'test_helper'

class Thinreports::Core::Shape::List::TestFormat < Minitest::Test
  include Thinreports::TestHelper

  LIST_FORMAT = {
    'type' => 'list',
    'id' => 'list',
    'display' => true,
    'x' => 10.0,
    'y' => 20.0,
    'width' => 30.0,
    'height' => 40.0,
    'content-height' => 255,
    'auto-page-break' => true,
    'header' => {
      'enabled' => true,
      'height' => 100.0,
      'translate' => { 'x' => 200.0, 'y' => 300.0 },
      'items' => []
    },
    'detail' => {
      'height' => 400.0,
      'translate' => { 'x' => 200.0, 'y' => 300.0 },
      'items' => []
    },
    'page-footer' => {
      'enabled' => true,
      'height' => 500.0,
      'translate' => { 'x' => 200.0, 'y' => 300.0 },
      'items' => []
    },
    'footer' => {
      'enabled' => false,
      'height' => 600.0,
      'translate' => { 'x' => 200.0, 'y' => 300.0 },
      'items' => []
    }
  }

  List = Thinreports::Core::Shape::List

  def test_has_section?
    format = List::Format.new(LIST_FORMAT)

    assert_equal true, format.has_section?(:detail)
    assert_equal true, format.has_section?(:page_footer)
    assert_equal false, format.has_section?(:footer)
  end

  def test_section_height
    format = List::Format.new(LIST_FORMAT)

    assert_equal 100.0, format.section_height(:header)
  end

  def test_attribute_readers
    format = List::Format.new(LIST_FORMAT)

    assert_equal 255, format.height
    assert_equal true, format.auto_page_break?
    assert_equal true, format.has_header?
    assert_equal true, format.has_page_footer?
    assert_equal false, format.has_footer?
    assert_equal 400.0, format.detail_height
    assert_equal 500.0, format.page_footer_height
    assert_equal 600.0, format.footer_height
    assert_equal 100.0, format.header_height
  end

  def test_initialize_sections
    format = List::Format.new(LIST_FORMAT)

    assert_instance_of List::SectionFormat, format.sections[:header]
    assert_instance_of List::SectionFormat, format.sections[:detail]
    assert_instance_of List::SectionFormat, format.sections[:page_footer]

    assert_nil format.sections[:footer]
  end
end
