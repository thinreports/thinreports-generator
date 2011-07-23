# coding: utf-8

module ThinReports
  
  module Report
    # @see ThinReports::Report::Base#initialize
    def self.new(*args)
      Base.new(*args)
    end
    
    # @see ThinReports::Report::Base#create
    def self.create(*args, &block)
      Base.create(*args, &block)
    end
    
    # @see ThinReports::Report::Base#generate
    def self.generate(*args, &block)
      Base.generate(*args, &block)
    end
    
    # @see ThinReports::Report::Base#generate_file
    def self.generate_file(*args, &block)
      Base.generate_file(*args, &block)
    end
  end
  
end

require 'thinreports/report/base'
require 'thinreports/report/internal'
require 'thinreports/report/events'