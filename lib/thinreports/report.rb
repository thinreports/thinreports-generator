# frozen_string_literal: true

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

require_relative 'report/base'
require_relative 'report/internal'
require_relative 'report/page'
