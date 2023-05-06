# frozen_string_literal: true

require 'json'
require 'rexml/document'

module Thinreports
  module BasicReport
    module Layout
      class LegacySchema
        include Utils

        def initialize(legacy_schema)
          @legacy_schema = legacy_schema
          @legacy_svg = legacy_schema['svg'].dup
          @legacy_item_schemas = extract_legacy_item_schemas(legacy_svg)

          @legacy_svg = cleanup_svg(@legacy_svg)
        end

        def upgrade
          config = legacy_schema['config']
          page_config = config['page']

          {
            'version' => legacy_schema['version'],
            'title' => legacy_schema['config']['title'],
            'report' => {
              'paper-type' => page_config['paper-type'],
              'width' => page_config['width'].to_f,
              'height' => page_config['height'].to_f,
              'orientation' => page_config['orientation'],
              'margin' => page_config.values_at(
                'margin-top',
                'margin-right',
                'margin-bottom',
                'margin-left'
              ).map(&:to_f)
            },
            'items' => item_schemas
          }
        end

        attr_reader :legacy_schema, :legacy_svg, :legacy_item_schemas

        def item_schemas
          svg = REXML::Document.new(legacy_svg)
          build_item_schemas_from_svg(svg.elements['/svg/g'])
        end

        def build_item_schemas_from_svg(svg_elements)
          return [] unless svg_elements

          items = []

          svg_elements.each do |item_element|
            item_attributes = item_element.attributes

            items <<
              case item_element.attributes['class']
              when 's-text' then text_item_schema(item_attributes, extract_texts_from(item_element))
              when 's-image' then image_item_schema(item_attributes)
              when 's-rect' then rect_item_schema(item_attributes)
              when 's-ellipse' then ellipse_item_schema(item_attributes)
              when 's-line' then line_item_schema(item_attributes)
              when 's-tblock' then text_block_item_schema(item_attributes)
              when 's-iblock' then image_block_item_schema(item_attributes)
              when 's-pageno' then page_number_item_schema(item_attributes)
              when 's-list' then list_item_schema(item_element)
              else raise 'Unknown item type'
              end
          end

          items
        end

        def text_item_schema(attributes, texts)
          {
            'id' => attributes['x-id'],
            'type' => Core::Shape::Text::TYPE_NAME,
            'x' => attributes['x-left'].to_f,
            'y' => attributes['x-top'].to_f,
            'width' => attributes['x-width'].to_f,
            'height' => attributes['x-height'].to_f,
            'display' => display(attributes['x-display']),
            'texts' => texts,
            'style' => {
              'font-family' => [attributes['font-family']],
              'font-size' => attributes['font-size'].to_f,
              'color' => attributes['fill'],
              'font-style' => font_style(attributes),
              'text-align' => text_align(attributes['text-anchor']),
              'vertical-align' => vertical_align(attributes['x-valign']),
              'line-height' => line_height(attributes['x-line-height']),
              'letter-spacing' => letter_spacing(attributes['kerning'])
            }
          }
        end

        def rect_item_schema(attributes)
          {
            'id' => attributes['x-id'],
            'type' => 'rect',
            'x' => attributes['x'].to_f,
            'y' => attributes['y'].to_f,
            'width' => attributes['width'].to_f,
            'height' => attributes['height'].to_f,
            'display' => display(attributes['x-display']),
            'border-radius' => attributes['rx'].to_i,
            'style' => {
              'border-width' => attributes['stroke-width'].to_f,
              'border-color' => attributes['stroke'],
              'border-style' => attributes['x-stroke-type'],
              'fill-color' => attributes['fill']
            }
          }
        end

        def line_item_schema(attributes)
          {
            'id' => attributes['x-id'],
            'type' => 'line',
            'x1' => attributes['x1'].to_f,
            'y1' => attributes['y1'].to_f,
            'x2' => attributes['x2'].to_f,
            'y2' => attributes['y2'].to_f,
            'display' => display(attributes['x-display']),
            'style' => {
              'border-width' => attributes['stroke-width'].to_f,
              'border-color' => attributes['stroke'],
              'border-style' => attributes['x-stroke-type']
            }
          }
        end

        def ellipse_item_schema(attributes)
          {
            'id' => attributes['x-id'],
            'type' => 'ellipse',
            'cx' => attributes['cx'].to_f,
            'cy' => attributes['cy'].to_f,
            'rx' => attributes['rx'].to_f,
            'ry' => attributes['ry'].to_f,
            'display' => display(attributes['x-display']),
            'style' => {
              'border-width' => attributes['stroke-width'].to_f,
              'border-color' => attributes['stroke'],
              'border-style' => attributes['x-stroke-type'],
              'fill-color' => attributes['fill']
            }
          }
        end

        def image_item_schema(attributes)
          _, image_type, image_data = attributes['xlink:href'].match(%r{^data:(image/[a-z]+?);base64,(.+)}).to_a

          {
            'id' => attributes['x-id'],
            'type' => 'image',
            'x' => attributes['x'].to_f,
            'y' => attributes['y'].to_f,
            'width' => attributes['width'].to_f,
            'height' => attributes['height'].to_f,
            'display' => display(attributes['x-display']),
            'data' => {
              'mime-type' => image_type,
              'base64' => image_data
            }
          }
        end

        def page_number_item_schema(attributes)
          {
            'id' => attributes['x-id'],
            'type' => Core::Shape::PageNumber::TYPE_NAME,
            'x' => attributes['x-left'].to_f,
            'y' => attributes['x-top'].to_f,
            'width' => attributes['x-width'].to_f,
            'height' => attributes['x-height'].to_f,
            'format' => attributes['x-format'],
            'target' => attributes['x-target'],
            'display' => display(attributes['x-display']),
            'style' => {
              'font-family' => [attributes['font-family']],
              'font-size' => attributes['font-size'].to_f,
              'color' => attributes['fill'],
              'font-style' => font_style(attributes),
              'text-align' => text_align(attributes['text-anchor']),
              'overflow' => attributes['x-overflow']
            }
          }
        end

        def image_block_item_schema(attributes)
          {
            'id' => attributes['x-id'],
            'type' => Core::Shape::ImageBlock::TYPE_NAME,
            'x' => attributes['x-left'].to_f,
            'y' => attributes['x-top'].to_f,
            'width' => attributes['x-width'].to_f,
            'height' => attributes['x-height'].to_f,
            'display' => display(attributes['x-display']),
            'style' => {
              'position-x' => attributes['x-position-x'],
              'position-y' => image_position_y(attributes['x-position-y'])
            }
          }
        end

        def text_block_item_schema(attributes)
          text_format = {
            'base' => attributes['x-format-base'],
            'type' => attributes['x-format-type']
          }
          case text_format['type']
          when 'datetime'
            text_format['datetime'] = {
              'format' => attributes['x-format-datetime-format']
            }
          when 'number'
            text_format['number'] = {
              'delimiter' => attributes['x-format-number-delimiter'],
              'precision' => attributes['x-format-number-precision'].to_i
            }
          when 'padding'
            text_format['padding'] = {
              'length' => attributes['x-format-padding-length'].to_i,
              'char' => attributes['x-format-padding-char'],
              'direction' => attributes['x-format-padding-direction']
            }
          end

          {
            'id' => attributes['x-id'],
            'type' => Core::Shape::TextBlock::TYPE_NAME,
            'x' => attributes['x-left'].to_f,
            'y' => attributes['x-top'].to_f,
            'width' => attributes['x-width'].to_f,
            'height' => attributes['x-height'].to_f,
            'display' => display(attributes['x-display']),
            'value' => attributes['x-value'],
            'multiple-line' => attributes['x-multiple'] == 'true',
            'format' => text_format,
            'reference-id' => attributes['x-ref-id'],
            'style' => {
              'font-family' => [attributes['font-family']],
              'font-size' => attributes['font-size'].to_f,
              'color' => attributes['fill'],
              'font-style' => font_style(attributes),
              'text-align' => text_align(attributes['text-anchor']),
              'vertical-align' => vertical_align(attributes['x-valign']),
              'line-height' => line_height(attributes['x-line-height']),
              'letter-spacing' => letter_spacing(attributes['kerning']),
              'overflow' => attributes['x-overflow'],
              'word-wrap' => attributes['x-word-wrap'] || ''
            }
          }
        end

        def list_item_schema(legacy_element)
          legacy_schema = legacy_item_schemas[legacy_element.attributes['x-id']]

          header = list_section_schema('header', legacy_element, legacy_schema)
          detail = list_section_schema('detail', legacy_element, legacy_schema)
          page_footer = list_section_schema('page-footer', legacy_element, legacy_schema)
          footer = list_section_schema('footer', legacy_element, legacy_schema)

          schema = {
            'id' => legacy_schema['id'],
            'type' => Core::Shape::List::TYPE_NAME,
            'content-height' => legacy_schema['content-height'].to_f,
            'auto-page-break' => legacy_schema['page-break'] == 'true',
            'display' => display(legacy_schema['display']),
            'header' => header,
            'detail' => detail,
            'page-footer' => page_footer,
            'footer' => footer
          }

          page_footer['translate']['y'] += detail['height'] if page_footer['enabled']

          if footer['enabled']
            footer['translate']['y'] += detail['height']
            footer['translate']['y'] += page_footer['height'] if page_footer['enabled']
          end
          schema
        end

        def list_section_schema(section_name, legacy_list_element, legacy_list_schema)
          legacy_section_schema = legacy_list_schema[section_name]
          return {} if legacy_section_schema.empty?

          section_item_elements = legacy_list_element.elements["g[@class='s-list-#{section_name}']"]

          section_schema = {
            'height' => legacy_section_schema['height'].to_f,
            'translate' => {
              'x' => legacy_section_schema['translate']['x'].to_f,
              'y' => legacy_section_schema['translate']['y'].to_f
            },
            'items' => build_item_schemas_from_svg(section_item_elements)
          }

          unless section_name == 'detail'
            section_schema['enabled'] = legacy_list_schema["#{section_name}-enabled"] == 'true'
          end
          section_schema
        end

        def extract_texts_from(text_item_element)
          [].tap do |texts|
            text_item_element.each_element('text') { |e| texts << e.text }
          end
        end

        def image_position_y(legacy_position_y)
          case legacy_position_y
          when 'top' then 'top'
          when 'center' then 'middle'
          when 'bottom' then 'bottom'
          end
        end

        def display(legacy_display)
          legacy_display == 'true'
        end

        def font_style(attributes)
          style = []
          style << 'bold' if attributes['font-weight'] == 'bold'
          style << 'italic' if attributes['font-style'] == 'italic'
          style << 'underline' if attributes['text-decoration'].include?('underline')
          style << 'linethrough' if attributes['text-decoration'].include?('line-through')
          style
        end

        def text_align(legacy_text_align)
          case legacy_text_align
          when 'start' then 'left'
          when 'middle' then 'center'
          when 'end' then 'right'
          else 'left'
          end
        end

        def vertical_align(legacy_vertical_align)
          return '' unless legacy_vertical_align

          case legacy_vertical_align
          when 'top' then 'top'
          when 'center' then 'middle'
          when 'bottom' then 'bottom'
          else 'top'
          end
        end

        def line_height(legacy_line_height)
          blank_value?(legacy_line_height) ? '' : legacy_line_height.to_f
        end

        def letter_spacing(legacy_letter_spacing)
          case legacy_letter_spacing
          when 'auto', '' then ''
          else legacy_letter_spacing.to_f
          end
        end

        def extract_legacy_item_schemas(svg)
          items = {}
          svg.scan(/<!--SHAPE(.*?)SHAPE-->/) do |(item_schema_json)|
            item_schema = JSON.parse(item_schema_json)
            items[item_schema['id']] = item_schema
          end
          items
        end

        def cleanup_svg(svg)
          cleaned_svg = svg.gsub(/<!--SHAPE.*?SHAPE-->/, '')
          cleaned_svg.gsub(/<!--LAYOUT(.*?)LAYOUT-->/) { $1 }
        end
      end
    end
  end
end
