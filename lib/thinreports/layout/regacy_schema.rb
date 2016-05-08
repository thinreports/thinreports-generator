# coding: utf-8

require 'json'
require 'rexml/document'

module Thinreports
  module Layout
    class RegacySchema
      def initialize(regacy_schema)
        @regacy_schema = regacy_schema
      end

      def upgrade
        config = regacy_schema['config']
        page_config = config['page']
        state = regacy_schema['state']

        {
          'version' => regacy_schema['version'],
          'title' => regacy_schema['config']['title'],
          'report' => {
            'paper-type' => page_config['paper-type'],
            'width' => page_config['width'].to_f,
            'height' => page_config['height'].to_f,
            'orientation' => page_config['orientation'],
            'margin' => page_config.values_at('margin-top', 'margin-right', 'margin-bottom', 'margin-left').map(&:to_f)
          },
          'items' => build_item_schemas_from_svg(regacy_schema['svg'].dup, '/svg/g', 1)
        }
      end

      attr_reader :regacy_schema

      def build_item_schemas_from_svg(svg, root_xpath, level)
        item_schemas = extract_item_schemas(svg, level)

        svg_doc = REXML::Document.new(normalize_svg(svg, level))
        items = []

        svg_doc.elements[root_xpath].each do |item_element|
          item_schema = item_schemas[item_element.attributes['x-id']] || {}
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
            when 's-list' then list_item_schema(item_schema)
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
            'font-family' => [ attributes['font-family'] ],
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
        _, image_type, image_data = attributes['xlink:href'].match(%r|^data:(image/[a-z]+?);base64,(.+)|).to_a

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
            'font-family' => [ attributes['font-family'] ],
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
          'style' => {
            'font-family' => [ attributes['font-family'] ],
            'font-size' => attributes['font-size'].to_f,
            'color' => attributes['fill'],
            'font-style' => font_style(attributes),
            'text-align' => text_align(attributes['text-anchor']),
            'vertical-align' => vertical_align(attributes['x-valign']),
            'line-height' => line_height(attributes['x-line-height']),
            'letter-spacing' => letter_spacing(attributes['kerning']),
            'overflow' => attributes['x-overflow'],
            'word-wrap' => attributes['x-word-wrap']
          }
        }
      end

      def list_item_schema(regacy_schema)
        {
          'id' => regacy_schema['id'],
          'type' => Core::Shape::List::TYPE_NAME,
          'content-height' => regacy_schema['content-height'].to_f,
          'auto-page-break' => regacy_schema['page-break'] == 'true',
          'display' => display(regacy_schema['display']),
          'header' => list_section_schema('header', regacy_schema),
          'detail' => list_section_schema('detail', regacy_schema),
          'page-footer' => list_section_schema('page-footer', regacy_schema),
          'footer' => list_section_schema('footer', regacy_schema)
        }
      end

      def list_section_schema(section_name, regacy_list_schema)
        regacy_section_schema = regacy_list_schema[section_name]

        section_svg = %(<svg xmlns:xlink="http://www.w3.org/1999/xlink">#{regacy_section_schema['svg']['content']}</svg>)

        section_schema = {
          'height' => regacy_section_schema['height'].to_f,
          'translate' => {
            'x' => regacy_section_schema['translate']['x'].to_f,
            'y' => regacy_section_schema['translate']['y'].to_f
          },
          'items' => build_item_schemas_from_svg(section_svg, '/svg', 2)
        }

        unless section_name == 'detail'
          section_schema['enabled'] = regacy_list_schema["#{section_name}-enabled"] == 'true'
        end
        section_schema
      end

      def extract_texts_from(text_item_element)
        [].tap do |texts|
          text_item_element.each_element('text') { |e| texts << e.text }
        end
      end

      def image_position_y(regacy_position_y)
        case regacy_position_y
        when 'top' then 'top'
        when 'center' then 'middle'
        when 'bottom' then 'bottom'
        end
      end

      def display(regacy_display)
        regacy_display == 'true'
      end

      def font_style(attributes)
        style = []
        style << 'bold' if attributes['font-weight'] == 'bold'
        style << 'italic' if attributes['font-style'] == 'italic'
        style << 'underline' if attributes['text-decoration'].include?('underline')
        style << 'linethrough' if attributes['text-decoration'].include?('line-through')
        style
      end

      def text_align(regacy_text_align)
        case regacy_text_align
        when 'start' then 'left'
        when 'middle' then 'center'
        when 'end' then 'right'
        else 'left'
        end
      end

      def vertical_align(regacy_vertical_align)
        return nil unless regacy_vertical_align

        case regacy_vertical_align
        when 'top' then 'top'
        when 'center' then 'middle'
        when 'bottom' then 'bottom'
        else 'top'
        end
      end

      def line_height(regacy_line_height)
        regacy_line_height == '' ? '' : regacy_line_height.to_f
      end

      def letter_spacing(regacy_letter_spacing)
        case regacy_letter_spacing
        when 'auto', '' then ''
        else regacy_letter_spacing.to_f
        end
      end

      def extract_item_schemas(svg, level)
        items = {}
        svg.scan(/<!--#{level_symbol(level)}SHAPE(.*?)SHAPE#{level_symbol(level)}-->/) do |(item_schema_json)|
          item_schema = JSON.parse(item_schema_json)
          items[item_schema['id']] = item_schema
        end
        items
      end

      def normalize_svg(svg, level)
        svg.gsub!(/<!--#{level_symbol(level)}SHAPE.*?SHAPE#{level_symbol(level)}-->/, '')
        svg.gsub!(/<!--#{level_symbol(level)}LAYOUT(.*?)LAYOUT#{level_symbol(level)}-->/) { $1 }
        svg
      end

      def level_symbol(level)
        '-' * (level - 1)
      end
    end
  end
end
