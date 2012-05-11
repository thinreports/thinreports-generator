# coding: utf-8

module ThinReports
  module Generator
    
    module PDF::Graphics
      # @param [Numeric, String] x1
      # @param [Numeric, String] y1
      # @param [Numeric, String] x2
      # @param [Numeric, String] y2
      # @param [Hash] attrs ({})
      # @option attrs [String] :stroke
      # @option attrs [Numeric, String] :stroke_width
      # @option attrs [Array<Integer, String>] :stroke_dash
      def line(x1, y1, x2, y2, attrs = {})
        with_graphic_styles(attrs) do
          pdf.line(pos(x1, y1), pos(x2, y2))
        end
      end
      
      # @param [Numeric, String] x
      # @param [Numeric, String] y
      # @param [Numeric, String] w width
      # @param [Numeric, String] h height
      # @param [Hash] attrs ({})
      # @option attrs [Integer, String] :radius
      # @option attrs [String] :stroke
      # @option attrs [Numeric, String] :stroke_width
      # @option attrs [Array<Integer, String>] :stroke_dash
      # @option attrs [String] :fill
      def rect(x, y, w, h, attrs = {})
        w, h   = s2f(w, h)
        radius = s2f(attrs[:radius])
        
        with_graphic_styles(attrs) do
          if radius && !radius.zero?
            pdf.rounded_rectangle(pos(x, y), w, h, radius)
          else
            pdf.rectangle(pos(x, y), w, h)
          end
        end
      end
      
      # @param [Numeric, String] x center-x
      # @param [Numeric, String] y center-y
      # @param [Numeric, String] rx
      # @param [Numeric, String] ry
      # @param [Hash] attrs ({})
      # @option attrs [String] :stroke
      # @option attrs [Numeric, String] :stroke_width
      # @option attrs [Array<Integer, String>] :stroke_dash
      # @option attrs [String] :fill
      def ellipse(x, y, rx, ry, attrs = {})
        rx, ry = s2f(rx, ry)
        
        with_graphic_styles(attrs) do
          pdf.ellipse(pos(x, y), rx, ry)
        end
      end
      
    private
      
      # @param [Hash] attrs
      def with_graphic_styles(attrs, &block)
        stroke = build_stroke_styles(attrs)
        fill   = build_fill_styles(attrs)
        
        # Do not draw if no colors given.
        return unless fill || stroke
        
        save_graphics_state

        # Apply stroke-dashed.
        if stroke && stroke[:dash]
          length, space = stroke[:dash]
          pdf.dash(length, :space => space)
        end
        
        case
        # Draw with fill and stroke.
        when fill && stroke
          pdf.fill_and_stroke {
            line_width(stroke[:width])
            pdf.fill_color(fill[:color])
            pdf.stroke_color(stroke[:color])
            block.call
          }
        # Draw only with fill.
        when fill
          pdf.fill {
            pdf.fill_color(fill[:color])
            block.call
          }
        # Draw only with stroke.
        when stroke
          pdf.stroke {
            line_width(stroke[:width])
            pdf.stroke_color(stroke[:color])
            block.call
          }
        end
        
        restore_graphics_state
      end      
      
      # @param [Hash] styles
      # @return [Hash, nil]
      def build_stroke_styles(styles)
        color = styles[:stroke]
        width = styles[:stroke_width]
        
        if color && color != 'none' && width && width != 0
          {:color => parse_color(color),
           :width => s2f(width),
           :dash  => s2f(*styles[:stroke_dash])}
        end
      end
      
      # @param [Hash] styles
      # @return [Hash, nil]
      def build_fill_styles(styles)
        color = styles[:fill]
        
        if color && color != 'none'
          {:color => parse_color(color)}
        end
      end      
      
    end
    
  end
end
