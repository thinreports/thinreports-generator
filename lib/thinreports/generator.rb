# coding: utf-8

module ThinReports

  module Generator
    # @param [Symbol] type
    # @param report (see ThinReports::Generator::Base#initialize)
    # @param options (see ThinReports::Generator::Base#initialize)
    def self.new(type, report, options = {})
      unless generator = registry[type]
        raise ThinReports::Errors::UnknownGeneratorType.new(type)
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

require 'thinreports/generator/configuration'
require 'thinreports/generator/base'
require 'thinreports/generator/pdf'
