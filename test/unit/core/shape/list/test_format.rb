# frozen_string_literal: true

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
      'height' => 10.0,
      'translate' => { 'x' => 210.0, 'y' => 310.0 },
      'items' => []
    },
    'detail' => {
      'height' => 20.0,
      'translate' => { 'x' => 220.0, 'y' => 320.0 },
      'items' => []
    },
    'page-footer' => {
      'enabled' => true,
      'height' => 30.0,
      'translate' => { 'x' => 230.0, 'y' => 330.0 },
      'items' => []
    },
    'footer' => {
      'enabled' => false,
      'height' => 40.0,
      'translate' => { 'x' => 240.0, 'y' => 340.0 },
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

    assert_equal 10.0, format.section_height(:header)
  end

  def test_attribute_readers
    format = List::Format.new(LIST_FORMAT)

    assert_equal 255, format.height
    assert_equal true, format.auto_page_break?
    assert_equal true, format.has_header?
    assert_equal true, format.has_page_footer?
    assert_equal false, format.has_footer?
    assert_equal 20.0, format.detail_height
    assert_equal 30.0, format.page_footer_height
    assert_equal 40.0, format.footer_height
    assert_equal 10.0, format.header_height
  end

  def test_section_base_position_top
    page_footer_disabled = LIST_FORMAT

    format = List::Format.new(page_footer_disabled)
    assert_equal 310.0, format.section_base_position_top(:header)
    assert_equal 320.0, format.section_base_position_top(:detail)
    assert_equal 310.0, format.section_base_position_top(:page_footer)
    assert_equal 0, format.section_base_position_top(:footer)

    format_footer_enabled = format_section_enabled(true, 'footer', LIST_FORMAT)

    format = List::Format.new(format_footer_enabled)
    assert_equal 290.0, format.section_base_position_top(:footer)

    format_footer_enabld_and_page_footer_disabled = format_section_enabled(false, 'page-footer', format_footer_enabled)

    format = List::Format.new(format_footer_enabld_and_page_footer_disabled)
    assert_equal 320.0, format.section_base_position_top(:footer)
  end

  def test_initialize_sections
    format = List::Format.new(LIST_FORMAT)

    assert_instance_of List::SectionFormat, format.sections[:header]
    assert_instance_of List::SectionFormat, format.sections[:detail]
    assert_instance_of List::SectionFormat, format.sections[:page_footer]

    assert_nil format.sections[:footer]
  end

  private

  def format_section_enabled(enable, section, list_format)
    section_format = list_format[section].dup
    section_format['enabled'] = enable

    list_format.merge(section => section_format)
  end
end
