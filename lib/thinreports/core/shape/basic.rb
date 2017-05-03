module Thinreports
  module Core
    module Shape
      module Basic
        TYPE_NAMES = %w[line rect ellipse image].freeze
      end
    end
  end
end

require 'thinreports/core/shape/basic/format'
require 'thinreports/core/shape/basic/internal'
require 'thinreports/core/shape/basic/interface'
require 'thinreports/core/shape/basic/block_format'
require 'thinreports/core/shape/basic/block_internal'
require 'thinreports/core/shape/basic/block_interface'
