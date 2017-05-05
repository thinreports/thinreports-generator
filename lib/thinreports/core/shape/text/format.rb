# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Text
        class Format < Basic::Format
          config_reader :texts
          config_reader valign: %w[style vertical-align]
          config_reader line_height: %w[style line-height]
        end
      end
    end
  end
end
