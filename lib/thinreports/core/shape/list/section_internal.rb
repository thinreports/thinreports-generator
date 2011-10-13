# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    class List::SectionInternal < Base::Internal
      format_delegators :height,
                        :relative_left,
                        :relative_top,
                        :svg_tag
      
      # @return [Symbol]
      attr_accessor :section_name
      
      def style
        @style ||= Style::Base.new(format)
      end
      
      # @param [Numeric] ry
      def move_top_to(ry)
        states[:relative_top] = ry
      end
      
      # @return [Array<Numeric>]
      def relative_position
        [relative_left,
         relative_top + (states[:relative_top] || 0)]
      end
    end
    
  end
end
