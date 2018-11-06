# frozen_string_literal: true

require 'test_helper'

class Thinreports::Layout::TestLegacySchema < Minitest::Test
  include Thinreports::TestHelper

  Layout = Thinreports::Layout

  def test_upgrade
    legacy_schema = {
      'version' => '0.8.2',
      'finger-print' => 'abcd',
      'config' => {
        'title' => 'Report Title',
        'page' => {
          'paper-type' => 'A4',
          'width' => '100.0',
          'height' => '200.0',
          'orientation' => 'landscape',
          'margin-top' => '0.1',
          'margin-right' => '0.2',
          'margin-bottom' => '0.3',
          'margin-left' => '0.4'
        }
      },
      'svg' => '<svg><g class="canvas"></g></svg>',
      'state' => {
        'layout-guide' => []
      }
    }

    assert_equal(
      {
        'version' => '0.8.2',
        'title' => 'Report Title',
        'report' => {
          'paper-type' => 'A4',
          'width' => 100.0,
          'height' => 200.0,
          'orientation' => 'landscape',
          'margin' => [0.1, 0.2, 0.3, 0.4]
        },
        'items' => []
      },
      Layout::LegacySchema.new(legacy_schema).upgrade
    )
  end

  def test_text_item_schema
    legacy_attributes = {
      'x-id' => 'text_id',
      'x-left' => '100.1',
      'x-top' => '200.1',
      'x-width' => '300.1',
      'x-height' => '400.1',
      'x-display' => 'true',
      'font-family' => 'Helvetica',
      'font-size' => '18',
      'font-weight' => 'normal',
      'font-style' => 'normal',
      'text-decoration' => 'underline line-through',
      'fill' => 'red',
      'text-anchor' => 'start',
      'x-valign' => 'top',
      'x-line-height' => '20.1',
      'kerning' => '2.1'
    }
    legacy_texts = %w( line1 line2 )

    assert_equal(
      {
        'id' => 'text_id',
        'type' => 'text',
        'x' => 100.1,
        'y' => 200.1,
        'width' => 300.1,
        'height' => 400.1,
        'display' => true,
        'texts' => %w( line1 line2 ),
        'style' => {
          'font-family' => %w( Helvetica ),
          'font-size' => 18.0,
          'color' => 'red',
          'font-style' => %w( underline linethrough ),
          'text-align' => 'left',
          'vertical-align' => 'top',
          'line-height' => 20.1,
          'letter-spacing' => 2.1
        }
      },
      layout_legacy_schema.text_item_schema(legacy_attributes, legacy_texts)
    )
  end

  def test_rect_item_schema
    legacy_attributes = {
      'x-id' => 'rect_id',
      'x' => '100.1',
      'y' => '200.1',
      'width' => '300.1',
      'height' => '400.1',
      'x-display' => 'false',
      'stroke-width' => '2.5',
      'stroke' => '#ff0000',
      'x-stroke-type' => 'dotted',
      'fill' => 'red',
      'rx' => '2'
    }
    assert_equal(
      {
        'id' => 'rect_id',
        'type' => 'rect',
        'x' => 100.1,
        'y' => 200.1,
        'width' => 300.1,
        'height' => 400.1,
        'display' => false,
        'border-radius' => 2,
        'style' => {
          'border-width' => 2.5,
          'border-color' => '#ff0000',
          'border-style' => 'dotted',
          'fill-color' => 'red'
        }
      },
      layout_legacy_schema.rect_item_schema(legacy_attributes)
    )
  end

  def test_line_item_schema
    legacy_attributes = {
      'x-id' => 'line_id',
      'x1' => '100.1',
      'y1' => '200.1',
      'x2' => '300.1',
      'y2' => '400.1',
      'x-display' => 'true',
      'stroke-width' => '1',
      'stroke' => 'red',
      'x-stroke-type' => 'solid'
    }
    assert_equal(
      {
        'id' => 'line_id',
        'type' => 'line',
        'x1' => 100.1,
        'y1' => 200.1,
        'x2' => 300.1,
        'y2' => 400.1,
        'display' => true,
        'style' => {
          'border-width' => 1.0,
          'border-color' => 'red',
          'border-style' => 'solid'
        }
      },
      layout_legacy_schema.line_item_schema(legacy_attributes)
    )
  end

  def test_ellipse_item_schema
    legacy_attributes = {
      'x-id' => 'ellipse_id',
      'cx' => '100.1',
      'cy' => '200.1',
      'rx' => '300.1',
      'ry' => '400.1',
      'x-display' => 'true',
      'stroke-width' => '1',
      'stroke' => 'red',
      'x-stroke-type' => 'solid',
      'fill' => 'blue'
    }
    assert_equal(
      {
        'id' => 'ellipse_id',
        'type' => 'ellipse',
        'cx' => 100.1,
        'cy' => 200.1,
        'rx' => 300.1,
        'ry' => 400.1,
        'display' => true,
        'style' => {
          'border-width' => 1.0,
          'border-color' => 'red',
          'border-style' => 'solid',
          'fill-color' => 'blue'
        }
      },
      layout_legacy_schema.ellipse_item_schema(legacy_attributes)
    )
  end

  def test_image_item_schema
    legacy_attributes = {
      'x-id' => 'image_id',
      'x' => '100.1',
      'y' => '200.1',
      'width' => '300.1',
      'height' => '400.1',
      'x-display' => 'true',
      'xlink:href' => 'data:image/png;base64,xxxxxxxxxxxxx'
    }
    assert_equal(
      {
        'id' => 'image_id',
        'type' => 'image',
        'x' => 100.1,
        'y' => 200.1,
        'width' => 300.1,
        'height' => 400.1,
        'display' => true,
        'data' => {
          'mime-type' => 'image/png',
          'base64' => 'xxxxxxxxxxxxx'
        }
      },
      layout_legacy_schema.image_item_schema(legacy_attributes)
    )
  end

  def test_page_number_item_schema
    legacy_attributes = {
      'x-id' => 'page_number_id',
      'x-left' => '100.1',
      'x-top' => '200.1',
      'x-width' => '300.1',
      'x-height' => '400.1',
      'x-format' => '{page}',
      'x-target' => 'report',
      'x-display' => 'true',
      'font-family' => 'IPAMincho',
      'font-size' => '18.5',
      'fill' => 'red',
      'font-weight' => 'bold',
      'font-style' => 'italic',
      'text-decoration' => '',
      'text-anchor' => 'end',
      'x-overflow' => 'fit'
    }
    assert_equal(
      {
        'id' => 'page_number_id',
        'type' => 'page-number',
        'x' => 100.1,
        'y' => 200.1,
        'width' => 300.1,
        'height' => 400.1,
        'format' => '{page}',
        'target' => 'report',
        'display' => true,
        'style' => {
          'font-family' => %w( IPAMincho ),
          'font-size' => 18.5,
          'color' => 'red',
          'font-style' => %w( bold italic ),
          'text-align' => 'right',
          'overflow' => 'fit'
        }
      },
      layout_legacy_schema.page_number_item_schema(legacy_attributes)
    )
  end

  def test_image_block_item_schema
    legacy_attributes = {
      'x-id' => 'image_block_id',
      'x-left' => '100.1',
      'x-top' => '200.1',
      'x-width' => '300.1',
      'x-height' => '400.1',
      'x-display' => 'false',
      'x-position-x' => 'right',
      'x-position-y' => 'bottom'
    }
    assert_equal(
      {
        'id' => 'image_block_id',
        'type' => 'image-block',
        'x' => 100.1,
        'y' => 200.1,
        'width' => 300.1,
        'height' => 400.1,
        'display' => false,
        'style' => {
          'position-x' => 'right',
          'position-y' => 'bottom'
        }
      },
      layout_legacy_schema.image_block_item_schema(legacy_attributes)
    )
  end

  def test_text_block_schema
    base_legacy_attributes = {
      'x-id' => 'text_block_id',
      'x-left' => '100.1',
      'x-top' => '200.1',
      'x-width' => '300.1',
      'x-height' => '400.1',
      'x-display' => 'true',
      'x-value' => 'default value',
      'x-multiple' => 'true',
      'font-family' => 'Helvetica',
      'font-size' => '18',
      'font-weight' => 'bold',
      'font-style' => 'normal',
      'text-decoration' => 'line-through',
      'fill' => 'red',
      'text-anchor' => 'start',
      'x-valign' => 'top',
      'x-line-height' => '20.1',
      'kerning' => '2.1',
      'x-overflow' => 'expand',
      'x-word-wrap' => 'break-word',
      'x-format-base' => '$ {value}',
      'x-format-type' => '',
      'x-ref-id' => 'other_text_block_id'
    }
    assert_equal(
      {
        'id' => 'text_block_id',
        'type' => 'text-block',
        'x' => 100.1,
        'y' => 200.1,
        'width' => 300.1,
        'height' => 400.1,
        'display' => true,
        'value' => 'default value',
        'multiple-line' => true,
        'reference-id' => 'other_text_block_id',
        'format' => {
          'base' => '$ {value}',
          'type' => ''
        },
        'style' => {
          'font-family' => %w( Helvetica ),
          'font-size' => 18.0,
          'color' => 'red',
          'font-style' => %w( bold linethrough ),
          'text-align' => 'left',
          'vertical-align' => 'top',
          'line-height' => 20.1,
          'letter-spacing' => 2.1,
          'overflow' => 'expand',
          'word-wrap' => 'break-word'
        }
      },
      layout_legacy_schema.text_block_item_schema(base_legacy_attributes)
    )

    schema_with_datetime_format = layout_legacy_schema.text_block_item_schema(base_legacy_attributes.merge(
      'x-format-type' => 'datetime',
      'x-format-datetime-format' => '%Y'
    ))
    assert_equal(
      {
        'base' => '$ {value}',
        'type' => 'datetime',
        'datetime' => {
          'format' => '%Y'
        }
      },
      schema_with_datetime_format['format']
    )

    schema_with_number_format = layout_legacy_schema.text_block_item_schema(base_legacy_attributes.merge(
      'x-format-type' => 'number',
      'x-format-number-precision' => '1',
      'x-format-number-delimiter' => ','
    ))
    assert_equal(
      {
        'base' => '$ {value}',
        'type' => 'number',
        'number' => {
          'delimiter' => ',',
          'precision' => 1
        }
      },
      schema_with_number_format['format']
    )

    schema_with_padding_format = layout_legacy_schema.text_block_item_schema(base_legacy_attributes.merge(
      'x-format-type' => 'padding',
      'x-format-padding-char' => '0',
      'x-format-padding-length' => '10',
      'x-format-padding-direction' => 'L'
    ))
    assert_equal(
      {
        'base' => '$ {value}',
        'type' => 'padding',
        'padding' => {
          'length' => 10,
          'char' => '0',
          'direction' => 'L'
        }
      },
      schema_with_padding_format['format']
    )
  end

  def test_list_item_schema
    legacy_schema = {
      'id' => 'default',
      'type' => 's-list',
      'content-height' => '300',
      'page-break' => 'true',
      'display' => 'false',
      'header-enabled' => 'false',
      'page-footer-enabled' => 'true',
      'footer-enabled' => 'true',
      'header' => {
        'height' => '100.1',
        'translate' => {
          'x' => '100',
          'y' => '200'
        },
        'svg' => { 'content' => '' }
      },
      'detail' => {
        'height' => '200.1',
        'translate' => {
          'x' => '300',
          'y' => '400'
        },
        'svg' => { 'content' => '' }
      },
      'page-footer' => {
        'height' => '300.1',
        'translate' => {
          'x' => '500',
          'y' => '600'
        },
        'svg' => { 'content' => '' }
      },
      'footer' => {
        'height' => '400.1',
        'translate' => {
          'x' => '700',
          'y' => '800'
        },
        'svg' => { 'content' => '' }
      }
    }

    layout_legacy_schema.stubs(:legacy_item_schemas).returns({ 'default' => legacy_schema })

    legacy_element = mock()
    legacy_element.stubs(:attributes).returns({ 'x-id' => 'default' })
    legacy_element.stubs(:elements).returns({})

    assert_equal(
      {
        'id' => 'default',
        'type' => 'list',
        'content-height' => 300.0,
        'auto-page-break' => true,
        'display' => false,
        'header' => {
          'height' => 100.1,
          'translate' => {
            'x' => 100.0,
            'y' => 200.0
          },
          'items' => [],
          'enabled' => false
        },
        'detail' => {
          'height' => 200.1,
          'translate' => {
            'x' => 300.0,
            'y' => 400.0
          },
          'items' => []
        },
        'page-footer' => {
          'height' => 300.1,
          'translate' => {
            'x' => 500.0,
            'y' => 800.1
          },
          'items' => [],
          'enabled' => true
        },
        'footer' => {
          'height' => 400.1,
          'translate' => {
            'x' => 700.0,
            'y' => 1300.2
          },
          'items' => [],
          'enabled' => true
        }
      },
      layout_legacy_schema.list_item_schema(legacy_element)
    )
  end

  def test_image_position_y
    assert_equal 'top', layout_legacy_schema.image_position_y('top')
    assert_equal 'middle', layout_legacy_schema.image_position_y('center')
    assert_equal 'bottom', layout_legacy_schema.image_position_y('bottom')
  end

  def test_display
    assert_equal true, layout_legacy_schema.display('true')
    assert_equal false, layout_legacy_schema.display('false')
  end

  def test_font_style
    no_style = {
      'font-weight' => 'normal',
      'font-style' => 'normal',
      'text-decoration' => 'none'
    }
    assert_equal [], layout_legacy_schema.font_style(no_style)
    assert_equal %w( bold ), layout_legacy_schema.font_style(no_style.merge('font-weight' => 'bold'))
    assert_equal %w( italic ), layout_legacy_schema.font_style(no_style.merge('font-style' => 'italic'))
    assert_equal %w( underline ), layout_legacy_schema.font_style(no_style.merge('text-decoration' => 'underline'))
    assert_equal %w( linethrough ), layout_legacy_schema.font_style(no_style.merge('text-decoration' => 'line-through'))
    assert_equal %w( underline linethrough ), layout_legacy_schema.font_style(no_style.merge('text-decoration' => 'line-through underline'))
  end

  def test_text_align
    assert_equal 'left', layout_legacy_schema.text_align('start')
    assert_equal 'center', layout_legacy_schema.text_align('middle')
    assert_equal 'right', layout_legacy_schema.text_align('end')
  end

  def test_vertical_align
    assert_equal '', layout_legacy_schema.vertical_align(nil)
    assert_equal 'top', layout_legacy_schema.vertical_align('top')
    assert_equal 'middle', layout_legacy_schema.vertical_align('center')
    assert_equal 'bottom', layout_legacy_schema.vertical_align('bottom')
    assert_equal 'top', layout_legacy_schema.vertical_align('')
  end

  def test_line_height
    assert_equal '', layout_legacy_schema.line_height('')
    assert_equal '', layout_legacy_schema.line_height(nil)
    assert_equal 20.1, layout_legacy_schema.line_height('20.1')
  end

  def test_letter_spacing
    assert_equal '', layout_legacy_schema.letter_spacing('')
    assert_equal '', layout_legacy_schema.letter_spacing('auto')
    assert_equal 2.5, layout_legacy_schema.letter_spacing('2.5')
  end

  def test_extract_item_schemas
    svg = <<-SVG
<!--SHAPE{"id":"item1"}SHAPE-->
<!--LAYOUT<rect id="item2"/>LAYOUT-->
<!--SHAPE{"id":"item3"}SHAPE-->
SVG
    assert_equal(
      { 'item1' => { 'id' => 'item1' }, 'item3' => { 'id' => 'item3' } },
      layout_legacy_schema.extract_legacy_item_schemas(svg)
    )
  end

  def test_cleanup_svg
    svg = '<!--SHAPE{"id":"item1"}SHAPE--><!--LAYOUT<rect id="item2"/>LAYOUT--><!--SHAPE{"id":"item2"}SHAPE-->'

    assert_equal '<rect id="item2"/>', layout_legacy_schema.cleanup_svg(svg)
  end

  private

  def layout_legacy_schema
    @layout_legacy_schema ||= Layout::LegacySchema.new({ 'svg' => '' })
  end
end
