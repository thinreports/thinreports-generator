# coding: utf-8

module Thinreports
  module Generator

    # @deprecated This class will be removed in the next major version.
    class Configuration
      # @return [Symbol]
      attr_reader :default

      def initialize
        @default = :pdf
      end

      # @return [Thinreports::Generator::PDF::Configuration]
      def pdf
        @pdf ||= PDF::Configuration.new
      end

      # @param [Symbol] type
      # @return [void]
      def default=(type)
        unless Generator.registry.key?(type)
          raise Thinreports::Errors::UnknownGeneratorType.new(type)
        end
        @default = type
      end
    end

  end
end
