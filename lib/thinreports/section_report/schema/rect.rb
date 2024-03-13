# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Schema
      class Rect < Schema::Base
        attributes :id, :type, :style
        attributes :x, :y, :width, :height

        attribute :display?, 'display'
        attribute :follow_stretch, 'follow-stretch'
        attribute :affect_bottom_margin?, 'affect-bottom-margin'
        attribute :border_radius, 'border-radius'

        def bottom
          y + height
        end
      end
    end
  end
end

