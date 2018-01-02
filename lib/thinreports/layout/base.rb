# frozen_string_literal: true

module Thinreports
  module Layout
    class Base
      EXT_NAME = 'tlf'.freeze
      include Utils

      class << self
        # @param [String] filename
        # @return [Thinreports::Layout::Format]
        # @raise [Thinreports::Errors::InvalidLayoutFormat]
        # @raise [Thinreports::Errors::IncompatibleLayoutFormat]
        def load_format(filename)
          filename += ".#{EXT_NAME}" unless filename =~ /\.#{EXT_NAME}$/

          raise Thinreports::Errors::LayoutFileNotFound unless File.exist?(filename)
          # Build format.
          Thinreports::Layout::Format.build(filename)
        end
      end

      attr_reader :format

      # @return [String]
      attr_reader :filename

      # @return [Symbol]
      attr_reader :id

      # @param [String] filename
      # @param [Hash] options
      # @option options [Symbol] :id (nil)
      def initialize(filename, options = {})
        @filename = filename
        @format = self.class.load_format(filename)
        @id = options[:id]
      end

      # @return [Boolean] Return the true if is default layout.
      def default?
        @id.nil?
      end
    end
  end
end
