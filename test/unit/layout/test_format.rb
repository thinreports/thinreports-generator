# frozen_string_literal: true

require 'test_helper'

class Thinreports::Layout::TestFormat < Minitest::Test
  include Thinreports::TestHelper

  LAYOUT_SCHEMA = {
    'version' => '0.9.0',
    'title' => 'Report Title',
    'report' => {
      'paper-type' => 'A4',
      'width' => 100.0,
      'height' => 200.0,
      'orientation' => 'landscape',
      'margin' => [100.0, 200.0, 300.0, 999.9]
    },
    'state' => {
      'layout-guides' => [
        { 'type' => 'x', 'position' => 0.1 }
      ]
    },
    'items' => [
      { 'type'=> 'rect', 'id'=> '', 'x'=> 100.0, 'y'=> 100.0, 'width'=> 100.0, 'height'=> 100.0, 'style'=> {'stroke-width'=> 1}},
      { 'type'=> 'text-block', 'id'=> 'text_block', 'x'=> 100.0, 'y'=> 100.0 },
      { 'type'=> 'page-number', 'id'=> '', 'x'=> 100.0, 'y'=> 100.0 }
    ]
  }

  Shape = Thinreports::Core::Shape
  Layout = Thinreports::Layout

  def test_attribute_readers
    format = Layout::Format.new(layout_schema)

    assert_equal 'Report Title', format.report_title
    assert_equal Thinreports::VERSION, format.last_version
    assert_equal 'A4', format.page_paper_type
    assert_equal 100.0, format.page_width
    assert_equal 200.0, format.page_height
    assert_equal 'landscape', format.page_orientation
  end

  def test_user_paper_type?
    format_paper_type_is_not_user = Layout::Format.new(layout_schema)
    assert_equal false, format_paper_type_is_not_user.user_paper_type?

    format_paper_type_is_user = Layout::Format.new(layout_schema.merge(
      {
        'report' => {
          'paper-type' => 'user'
        }
      }
    ))
    assert_equal true, format_paper_type_is_user.user_paper_type?
  end

  def test_build
    compatible_layout_file = layout_file
    assert_instance_of Layout::Format, Layout::Format.build(compatible_layout_file.path)

    incompatible_layout_file = layout_file(version: '0.0.1')
    assert_raises Thinreports::Errors::IncompatibleLayoutFormat do
      Layout::Format.build(incompatible_layout_file.path)
    end
  end

  def test_build_legacy_layout
    format = nil

    assert_deprecated { format = Layout::Format.build(data_file('legacy_layout', 'all-items.tlf')) }

    assert_equal 'Report Title', format.report_title
    assert_equal '0.8.2', format.last_version
    assert_equal 'A4', format.page_paper_type
    assert_equal 'portrait', format.page_orientation

    item_types = format.attributes['items'].map { |items| items['type'] }

    assert_equal 9, item_types.count
    assert_equal %w( rect ellipse line image image-block text-block list page-number text ).sort,
      item_types.sort
  end

  def test_initialize_items
    format = Layout::Format.new(layout_schema)

    assert_equal 2, format.shapes.count

    shape_classes = format.shapes.values.map(&:class)
    assert_includes shape_classes, Shape::TextBlock::Format
    assert_includes shape_classes, Shape::PageNumber::Format
  end

  private

  def layout_schema(version = Thinreports::VERSION)
    LAYOUT_SCHEMA.merge('version' => version)
  end
end
