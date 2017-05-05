# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Manager
        class Format < Core::Format::Base
          # @return [Symbol, Integer]
          attr_reader :identifier

          def initialize(config, id = nil, &block)
            super(config, &block)
            @identifier = id || object_id
          end

          def find_shape(id)
            shapes[id]
          end

          def has_shape?(id)
            shapes.key?(id)
          end

          def shapes
            @shapes ||= {}
          end
        end
      end
    end
  end
end
