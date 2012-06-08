# coding: utf-8

require 'rexml/document'

module ThinReports
  module Generator
    
    # @private
    module PDF::ParseSVG
      # @param [String] source
      # @param [String] base_path
      def parse_svg(source, base_path)
        svg = REXML::Document.new(clean_svg(source))
        
        svg.elements[base_path].each do |elm|
          case elm.attributes['class']
          when 's-text'    then draw_svg_text(elm)
          when 's-image'   then draw_svg_image(elm)
          when 's-rect'    then draw_svg_rect(elm)
          when 's-ellipse' then draw_svg_ellipse(elm)
          when 's-line'    then draw_svg_line(elm)
          end
        end
        svg = nil
      end
      
    private
      
      # @param [String] source
      # @return [String]
      def clean_svg(source)
        source.gsub(/<%.+?%>/, '')
      end
      
      # @param [REXML::Element] elm
      # @param [Array<String>] keys
      # @return [Array<String>]
      def element_attributes_values_at(elm, *keys)
        attrs = elm.attributes
        keys.inject([]) do |values, key|
          values << attrs[key]
        end
      end
      
      # @param [REXML::Element] elm
      def draw_svg_rect(elm)
        x, y, w, h = element_attributes_values_at(elm, 'x', 'y', 'width', 'height')
        attributes = common_graphic_attrs(elm.attributes) do |attrs|
          attrs[:radius] = elm.attributes['rx']
        end
        rect(x, y, w, h, attributes)
      end
      
      # @see #draw_svg_rect
      def draw_svg_ellipse(elm)
        x, y, rx, ry = element_attributes_values_at(elm, 'cx', 'cy', 'rx', 'ry')
        ellipse(x, y, rx, ry,
                common_graphic_attrs(elm.attributes))
      end
      
      # @see #draw_svg_rect
      def draw_svg_line(elm)
        x1, y1, x2, y2 = element_attributes_values_at(elm, 'x1', 'y1', 'x2', 'y2')
        line(x1, y1, x2, y2,
             common_graphic_attrs(elm.attributes))
      end
      
      # @see #draw_svg_rect
      def draw_svg_text(elm)
        x, y, w, h = element_attributes_values_at(elm, 'x-left', 'x-top',
                                                       'x-width', 'x-height')
        content = []
        elm.each_element('text') do |text_elm|
          content << text_elm.text
        end
        text(content.join("\n"), x, y, w, h, svg_text_attrs(elm.attributes))
      end
      
      # @see #draw_svg_rect
      def draw_svg_image(elm)
        x, y, w, h = element_attributes_values_at(elm, 'x', 'y', 'width', 'height')
        base64image(extract_base64_string(elm.attributes['xlink:href']),
                    x, y, w, h)
      end
    
      # @param [Hash] attributes
      # @return [Hash]
      def svg_text_attrs(attributes)
        common_text_attrs(attributes) do |attrs|
          # Set the :line_height option.
          if height = attributes['x-line-height']
            attrs[:line_height] = height unless height == 'normal'
          end
          # Set the :valign option.
          attrs[:valign] = text_valign(attributes['x-valign'])
        end
      end
      
    end
    
  end
end
