# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    class Text::Internal < Basic::Internal
      # Delegate to Format's methods
      format_delegators :svg_content, :text, :box
      
      def style
        @style ||= Style::Text.new(format)
      end
      
      def type_of?(type_name)
        type_name == :text
      end
    end
    
  end
end