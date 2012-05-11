# coding: utf-8

module ThinReports
  module Generator
    
    module PDF::Graphics
      # @param [Hash] svg_attrs
      # @yield [attrs]
      # @yieldparam [Hash] attrs
      # @return [Hash]
      def common_graphic_attrs(svg_attrs, &block)
        attrs = {:stroke       => svg_attrs['stroke'],
                 :stroke_width => svg_attrs['stroke-width'],
                 :fill         => svg_attrs['fill']}
        
        # Set 0 to stroke_width if stroke_opacity is '0'.
        if svg_attrs['stroke-opacity'] == '0'
          attrs[:stroke_width] = 0
        end
        
        # Setting for stroke dash.
        if (dash = svg_attrs['stroke-dasharray']) && dash != 'none'
          attrs[:stroke_dash] = dash.split(',')
        end
        block.call(attrs) if block_given?
        attrs
      end
      
      # @param [Hash] svg_attrs
      # @yield [attrs]
      # @yieldparam [Hash] attrs
      # @return [Hash]
      def common_text_attrs(svg_attrs, &block)
        attrs = {:font   => default_family_if_missing(svg_attrs['font-family']),
                 :size   => svg_attrs['font-size'],
                 :color  => svg_attrs['fill'],
                 :align  => text_align(svg_attrs['text-anchor']),
                 :styles => font_styles(svg_attrs)}
        
        # The Letter Spacing Property.
        # 
        # When the version of Layout is
        #   smaller then 0.6.0: 
        #     Use letter-spacing attribute (normal is none).
        #   0.6.0 or more:
        #     Use kerning attribute (auto is none).
        # 
        if space = text_letter_spacing(svg_attrs['kerning'] || svg_attrs['letter-spacing'])
          attrs[:letter_spacing] = space
        end
        block.call(attrs) if block_given?
        attrs
      end
      
      # @param [Hash] svg_attrs
      # @return [Array<Symbol>]
      def font_styles(svg_attrs)
        styles = []
        styles << :bold   if svg_attrs['font-weight'] == 'bold'
        styles << :italic if svg_attrs['font-style'] == 'italic'
        
        if (deco = svg_attrs['text-decoration']) && deco != 'none'
          deco = deco.split(' ')
          styles << :underline     if deco.include?('underline')
          styles << :strikethrough if deco.include?('line-through')
        end
        styles
      end
      
      # @param [String] space
      # @return [String, nil]
      def text_letter_spacing(space)
        %w( normal auto ).include?(space) ? nil : space
      end
      
      # @param [String] svg_align
      # @return [Symbol]
      def text_align(svg_align)
        case svg_align
        when 'start'  then :left
        when 'middle' then :center
        when 'end'    then :right
        else :left
        end
      end
      
      # @param [String] svg_valign
      # @return [Symbol]
      def text_valign(svg_valign)
        case svg_valign
        when 'top'    then :top
        when 'center' then :center
        when 'bottom' then :bottom
        else :top
        end
      end
      
      # @param [String] overflow
      # @return [Symbol]
      def text_overflow(overflow)
        case overflow
        when 'truncate' then :truncate
        when 'fit'      then :shrink_to_fit
        when 'expand'   then :expand
        else :truncate
        end
      end
        
      # @param [String] xlink
      # @return [String]
      def extract_base64_string(xlink)
        xlink.sub(%r{^data:image/[a-z]+?;base64,}, '')
      end
    end
    
  end
end
