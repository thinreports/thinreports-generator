# coding: utf-8

module Thinreports
  module Core::Shape

    class List::Store < ::Struct
      include Utils

      def self.init(attrs)
        new(attrs).new
      end

      def self.new(attrs)
        super(*attrs.keys) do
          @default_values = attrs.values

          def self.default_values
            deep_copy(@default_values)
          end
        end
      end

      def initialize
        super(*self.class.default_values)
      end

      def copy
        self.class.new
      end
    end

  end
end
