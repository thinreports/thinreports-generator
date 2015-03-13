# coding: utf-8

module ThinReports
  module Layout

    class Base
      EXT_NAME = 'tlf'

      class << self
        # @param [String] filename
        # @return [ThinReports::Layout::Format]
        # @raise [ThinReports::Errors::InvalidLayoutFormat]
        # @raise [ThinReports::Errors::IncompatibleLayoutFormat]
        # @private
        def load_format(filename)
          filename += ".#{EXT_NAME}" unless filename =~/\.#{EXT_NAME}$/

          unless File.exists?(filename)
            raise ThinReports::Errors::LayoutFileNotFound
          end
          # Build format.
          ThinReports::Layout::Format.build(filename)
        end
      end

      # @private
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
        @format   = self.class.load_format(filename)
        @id       = options[:id]
      end

      # @return [Boolean] Return the true if is default layout.
      def default?
        @id.nil?
      end

      # @yield [config]
      # @yieldparam [List::Configuration] config
      # @return [List::Configuration]
      def config(&block)
        @config ||= Layout::Configuration.new(self)
        block_exec_on(@config, &block)
      end

      # @param [ThinReports::Report::Base] parent
      # @param [Hash] options ({})
      # @option option [Boolean] :count (true)
      # @return [Page]
      # @private
      def new_page(parent, options = {})
        Core::Page.new(parent, self, options)
      end
    end

  end
end
