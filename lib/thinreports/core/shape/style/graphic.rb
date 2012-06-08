# coding: utf-8

module ThinReports
  module Core::Shape
    
    class Style::Graphic < Style::Basic
      style_accessible :border_color, :border_width, :fill_color, :border, 
                       :fill, :stroke
      
      # @method border_color
      #   @return [String]
      # @method border_color=(color)
      #   @param [String] color
      style_accessor :border_color, 'stroke'
      
      # @method border_width
      #   @return [String, Number]
      style_reader :border_width, 'stroke-width'
      
      # @method fill_color
      #   @return [String]
      # @method fill_color=(color)
      #   @param [String] color
      style_accessor :fill_color, 'fill'
      
      # @method fill
      #   @return [String]
      # @method fill=(color)
      #   @param [String] color
      # @deprecated Please use the #fill_color method instead.
      style_accessor :fill, 'fill'
      
      # @method stroke
      #   @return [String, Number]
      # @method stroke=(width)
      #   @param [String, Number] width
      # @deprecated Please use the #stroke_width method instead.
      style_accessor :stroke, 'stroke-width'
      
      # @param [String, Number] width
      def border_width=(width)
        write_internal_style('stroke-opacity', '1') unless width.to_i.zero?
        write_internal_style('stroke-width', width)
      end
      
      # @return [Array<String, Number>]
      def border
        [self.border_width, self.border_color]
      end
      
      # @param [Array<String, Number>] width_and_color
      def border=(width_and_color)
        w, c = width_and_color
        self.border_width = w
        self.border_color = c
      end
    end
    
  end
end
