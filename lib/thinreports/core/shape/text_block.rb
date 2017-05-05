# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module TextBlock
        TYPE_NAME = 'text-block'.freeze
      end
    end
  end
end

require_relative 'text_block/format'
require_relative 'text_block/internal'
require_relative 'text_block/interface'
require_relative 'text_block/formatter'
