# coding: utf-8

module ThinReports
  module Generator
    
    class Configuration
      # @return [Symbol]
      attr_reader :default
      
      def initialize
        @default = :pdf
      end
      
      # @return [ThinReports::Generator::PDF::Configuration]
      def pdf
        @pdf ||= PDF::Configuration.new
      end
      
      # @param [Symbol] type
      # @return [void]
      def default=(type)
        unless Generator.registry.key?(type)
          raise ThinReports::Errors::UnknownGeneratorType.new(type)
        end
        @default = type
      end
    end
    
  end
end