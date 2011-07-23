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
        
        # @private
        def Page
          const_defined?(:Page) ? Page : Core::Page
        end
        
      private
        
        # @private
        def PageHelpers(&block)
          const_set(:Page, ::Class.new(Core::Page, &block))
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
      # @return [Page]
      # @private
      def init_new_page(parent)
        self.class.Page.new(parent, self)
      end
    end
    
  end
end
