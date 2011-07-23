# coding: utf-8

module ThinReports
  module Core::Shape
    
    class List::Store < ::Struct
      # @private
      def self.init(attrs)
        new(attrs).new
      end
      
      # @private
      def self.new(attrs)
        super(*attrs.keys) do
          @default_values = attrs.values
          
          def self.default_values
            @default_values.simple_deep_copy
          end
        end
      end
      
      def initialize
        super(*self.class.default_values)
      end
      
      # @private
      def copy
        self.class.new
      end
    end
    
  end
end
