# coding: utf-8

module ThinReports

  module Generator
    # @private
    def self.new(type, report, options = {})
      unless generator = registry[type]
        raise ThinReports::Errors::UnknownGeneratorType
      end
      generator.new(report, options)
    end
    
    # @private
    def self.register(type, generator)
      registry[type] = generator
    end
    
    # @private
    def self.registry
      @generators ||= {}
    end
  end
end

require 'thinreports/generator/base'
require 'thinreports/generator/pxd'
require 'thinreports/generator/pdf'
