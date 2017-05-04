require 'pathname'

module Thinreports
  def self.root
    @root ||= Pathname.new(__FILE__).join('..', '..')
  end
end

require 'thinreports/version'
require 'thinreports/config'
require 'thinreports/core/utils'
require 'thinreports/core/errors'
require 'thinreports/core/format/base'
require 'thinreports/core/shape'
require 'thinreports/core/utils'
require 'thinreports/report'
require 'thinreports/layout'
require 'thinreports/generator/pdf'
