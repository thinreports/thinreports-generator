# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Report
      module Style
        class Base
          class << self
            def style(method_name, key)
              define_method(method_name.to_sym) { style[key] }
              define_method(:"#{method_name}=") { |value| style[key] = value }
            end
          end

          def initialize(schema_style)
            @style = schema_style.dup
          end

          def [](name)
            public_send(name.to_sym)
          end

          def []=(name, value)
            public_send(:"#{name}=", value)
          end

          private

          attr_reader :style
        end
      end
    end
  end
end
