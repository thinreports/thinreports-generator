# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Schema
      class StackView < Schema::Base
        attributes :id, :type

        attribute :display?, 'display'
        attribute :follow_stretch, 'follow-stretch'
        attribute :affect_bottom_margin?, 'affect-bottom-margin'

        def rows
          @rows ||= schema['rows'].map { |row|
            Schema::StackViewRow.new(row)
          }
        end

        def style
          schema['style'] || {}
        end

        def height
          @height ||= rows.sum(&:height)
        end

        def bottom
          y + height
        end
      end
    end
  end
end
