# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Schema
      module StackViewRow < Schema::Base
        include ItemContainer

        attributes :id, :height

        attribute :display?, 'display'
        attribute :auto_stretch?, 'auto-stretch'

        def initialize(schema)
          super

          initialize_items
        end
      end
    end
  end
end

