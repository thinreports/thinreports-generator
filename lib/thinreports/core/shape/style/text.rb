# coding: utf-8

module ThinReports
  module Core::Shape
    
    class Style::Text < Style::Basic
      TEXT_ALIGN_NAMES = {:left   => 'start',
                          :center => 'middle',
                          :right  => 'end'}
      
      style_accessible :bold, :italic, :underline, :linethrough,
                       :align, :valign, :color
      
      # @method color
      #   @return [String]
      # @method color=(v)
      #   @param [String] v
      style_accessor :color, 'fill'
      
      def initialize(*args)
        super
        @valign = default_valign
      end
      
      def copy
        new_style = super
        new_style.valign = self.valign
        new_style
      end
      
      def identifier
        super + (@valign == default_valign ? '' : @valign.to_s)
      end
      
      # @return [Boolean]
      def bold
        read_internal_style('font-weight') == 'bold'
      end
      
      # @param [Boolean] enable
      def bold=(enable)
        write_internal_style('font-weight', enable ? 'bold' : 'normal')
      end
      
      # @return [Boolean]
      def italic
        read_internal_style('font-style') == 'italic'
      end
      
      # @param [Boolean] enable
      def italic=(enable)
        write_internal_style('font-style', enable ? 'italic' : 'normal')
      end
      
      # @return [Boolean]
      def underline
        read_internal_style('text-decoration').include?('underline')
      end
      
      # @param [Boolean] enable
      def underline=(enable)
        text_decoration(enable, linethrough)
      end
      
      # @return [Boolean]
      def linethrough
        read_internal_style('text-decoration').include?('line-through')
      end
      
      # @param [Boolean] enable
      def linethrough=(enable)
        text_decoration(underline, enable)
      end
      
      # @return [Symbol]
      def align
        interface_text_align(read_internal_style('text-anchor'))
      end
      
      # @param [:left, :center, :right] align_name
      def align=(align_name)
        verify_style_value(align_name, TEXT_ALIGN_NAMES.keys,
                           'Only :left or :center, :right can be specified as align.')
        write_internal_style('text-anchor', internal_text_align(align_name))
      end
      
      # @return [Symbol]
      def valign
        @valign
      end
      
      # @param [:top, :center, :bottom] valign_name
      def valign=(valign_name)
        verify_style_value(valign_name, [:top, :center, :bottom],
                           'Only :top or :center, :bottom can be specified as valign.')
        @valign = valign_name
      end
    
    private
      
      # @return [Symbol]
      def default_valign
        @format.valign.blank? ? :top : @format.valign.to_sym
      end
      
      # @param [Symbol] align The interface align name.
      # @return [String, nil]
      def internal_text_align(align)
        TEXT_ALIGN_NAMES[align]
      end
      
      # @param [String] align The internal align name.
      # @return [Symbol]
      def interface_text_align(align)
        TEXT_ALIGN_NAMES.invert[align] || :left
      end
      
      # @param [Boolean] u
      # @param [Boolean] s
      def text_decoration(u, s)
        deco = case
        when u && s
          'underline line-through'
        when u && !s
          'underline'
        when !u && s
          'line-through'
        else
          'none'
        end
        write_internal_style('text-decoration', deco)
      end
    end
    
  end
end
