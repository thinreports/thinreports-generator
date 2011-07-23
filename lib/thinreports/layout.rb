# coding: utf-8

module ThinReports
  
  module Layout
    # @see ThinReports::Layout::Base#initialize
    def self.new(filename, options = {})
      Base.new(filename, options)
    end
  end
  
end

require 'thinreports/layout/version'
require 'thinreports/layout/base'
require 'thinreports/layout/format'
require 'thinreports/layout/configuration'