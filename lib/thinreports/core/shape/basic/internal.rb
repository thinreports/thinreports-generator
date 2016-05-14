# coding: utf-8

module Thinreports
  module Core::Shape

    class Basic::Internal < Base::Internal
      # Delegate to Format's methods
      format_delegators :id, :type

      def style
        @style ||= Style::Graphic.new(format)
      end

      def type_of?(type_name)
        [:basic, self.type].include?(type_name)
      end

      def identifier
        "#{id}#{style.identifier}"
      end
    end
  end
end
