# coding: utf-8

module ThinReports
  module Generator
    
    module Pdf::Graphics
      # @param [Hash] svg_attrs
      # @yield [attrs]
      # @yieldparam [Hash] attrs
      # @return [Hash]
      def common_graphic_attrs(svg_attrs, &block)
        attrs = {:stroke       => svg_attrs['stroke'],
                 :stroke_width => svg_attrs['stroke-width'],
                 :fill         => svg_attrs['fill']}
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
        # Letter Spacing.
        if space = svg_attrs['letter-spacing']
          attrs[:letter_spacing] = space unless space == 'normal'
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
      
      # @param [String] xlink
      # @return [String]
      def extract_base64_string(xlink)
        xlink.sub(%r{^data:image/[a-z]+?;base64,}, '')
      end
    end
    
  end
end
