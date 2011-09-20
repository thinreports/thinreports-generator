# coding: utf-8

module ThinReports
  module Core::Shape
    
    module Basic
      TYPE_NAMES = %w( s-line s-rect s-ellipse s-image )
    end
    
  end
end

require 'thinreports/core/shape/basic/format'
require 'thinreports/core/shape/basic/internal'
require 'thinreports/core/shape/basic/interface'
require 'thinreports/core/shape/basic/block_format'
require 'thinreports/core/shape/basic/block_internal'
require 'thinreports/core/shape/basic/block_interface'
