# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module ImageBlock
        TYPE_NAME = 'image-block'.freeze
      end
    end
  end
end

require_relative 'image_block/format'
require_relative 'image_block/internal'
require_relative 'image_block/interface'
