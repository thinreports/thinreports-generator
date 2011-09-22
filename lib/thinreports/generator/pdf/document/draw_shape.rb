# coding: utf-8

module ThinReports
  module Generator
    
    # @private
    module PDF::DrawShape
      # @param [ThinReports::Core::Shape::TextBlock::Internal] shape
      def draw_shape_tblock(shape)
        x, y, w, h = shape.box.values_at('x', 'y', 'width', 'height')
        
        content = shape.real_value.to_s
        
        unless content.empty?
          unless shape.multiple?
            content = content.gsub(/\n/, ' ')
          end
          text_box(content, x, y, w, h, shape_text_attrs(shape))
        end
      end
      
      # @param [ThinReports::Core::Shape::Basic::Internal] shape
      def draw_shape_image(shape)
        x, y, w, h = shape.svg_attrs.values_at('x', 'y', 'width', 'height')
        base64image(extract_base64_string(shape.svg_attrs['xlink:href']),
                    x, y, w, h)
      end
      
      # @param [ThinReports::Core::Shape::ImageBlock::Internal] shape
      def draw_shape_iblock(shape)
        x, y, w, h = shape.box.values_at('x', 'y', 'width', 'height')
        unless shape.src.blank?
          posx = shape.format.position_x
          posy = shape.format.position_y
          
          image_box(shape.src, x, y, w, h,
                    :position_x => posx ? posx.to_sym : nil,
                    :position_y => posy ? posy.to_sym : nil)
        end
      end
      
      # @param [ThinReports::Core::Shape::Text::Internal] shape
      def draw_shape_text(shape)
        x, y, w, h = shape.box.values_at('x', 'y', 'width', 'height')
        text(shape.text.join("\n"), x, y, w, h, 
             shape_text_attrs(shape))
      end
      
      # @param [ThinReports::Core::Shape::Basic::Internal] shape
      def draw_shape_ellipse(shape)
        args = shape.svg_attrs.values_at('cx', 'cy', 'rx', 'ry')
        args << common_graphic_attrs(shape.attributes)
        ellipse(*args)
      end
      
      # @param [ThinReports::Core::Shape::Basic::Internal] shape
      def draw_shape_line(shape)
        args = shape.svg_attrs.values_at('x1', 'y1', 'x2', 'y2')
        args << common_graphic_attrs(shape.attributes)
        line(*args)
      end
      
      # @param [ThinReports::Core::Shape::Basic::Internal] shape
      def draw_shape_rect(shape)
        args = shape.svg_attrs.values_at('x', 'y', 'width', 'height')
        args << common_graphic_attrs(shape.attributes) do |attrs|
          attrs[:radius] = shape.svg_attrs['rx']
        end
        rect(*args)
      end
    
    private
      
      # @param [ThinReports::Core::Shape::Text::Internal, ThinReports::Core::Shape::TextBlock::Internal]
      # @return [Hash]
      def shape_text_attrs(shape)
        format = shape.format
        
        common_text_attrs(shape.attributes) do |attrs|
          # Set the :line_height option.
          attrs[:line_height] = format.line_height unless format.line_height.blank?
          # Set the :valign option.
          attrs[:valign]      = text_valign(format.valign)
        end
      end
      
    end
    
  end
end
