# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Basic
        TYPE_NAMES = %w[line rect ellipse image].freeze
      end
    end
  end
end

require_relative 'basic/format'
require_relative 'basic/internal'
require_relative 'basic/interface'
require_relative 'basic/block_format'
require_relative 'basic/block_internal'
require_relative 'basic/block_interface'
