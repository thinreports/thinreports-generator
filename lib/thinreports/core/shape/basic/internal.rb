# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    class Basic::Internal < Base::Internal
      # Delegate to Format's methods
      format_delegators :id, :svg_tag, :svg_attrs, :type
      
      def visible(visibility)
        states[:display] = visibility
      end
      
      def visible?
        states.key?(:display) ? states[:display] : format.display?
      end
      
      def svg_attr(attr_name, value)
        attrs[attr_name.to_s] = value
      end
      
      def type_of?(type_name)
        ['s-basic', self.type].include?("s-#{type_name}")
      end
    end
    
  end
end