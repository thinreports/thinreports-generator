# frozen_string_literal: true

module Thinreports
  module Layout
    # @see Thinreports::Layout::Base#initialize
    def self.new(filename, options = {})
      Base.new(filename, options)
    end
  end
end

require_relative 'layout/version'
require_relative 'layout/base'
require_relative 'layout/format'
require_relative 'layout/legacy_schema'
