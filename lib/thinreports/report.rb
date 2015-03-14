# coding: utf-8

module Thinreports

  module Report
    # @see Thinreports::Report::Base#initialize
    def self.new(*args)
      Base.new(*args)
    end

    # @see Thinreports::Report::Base#create
    def self.create(*args, &block)
      Base.create(*args, &block)
    end

    # @see Thinreports::Report::Base#generate
    def self.generate(*args, &block)
      Base.generate(*args, &block)
    end
  end

end

require 'thinreports/report/base'
require 'thinreports/report/internal'
require 'thinreports/report/events'
