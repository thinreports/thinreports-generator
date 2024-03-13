# frozen_string_literal: true

require 'forwardable'
require 'style'

module Thinreports
  module SectionReport
    module Report
      module Item
        class Base
          extend Forwardable

          attr_reader :schema, :state
          def_delegator :schema, :id

          def initialize(schema)
            @schema = schema
            @state = {}
          end

          def display?
            state.fetch(:display) { schema.display? }
          end

          def display=(visibility)
            state[:display] = visibility
          end

          def render
            raise NotImplementedError
          end
        end
      end
    end
  end
end
