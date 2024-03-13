# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Schema
      class Base
        class << self
          def attribute(name, *keys)
            define_method(name) { schema.dig(keys.empty? ? name : *keys) }
          end

          def attributes(*names)
            names.each { |name| attribute(name) }
          end
        end

        attr_reader :schema

        def initialize(schema)
          @schema = schema
        end
      end
    end
  end
end
