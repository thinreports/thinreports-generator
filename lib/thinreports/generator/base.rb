# coding: utf-8

module ThinReports
  module Generator
    
    # @abstract
    class Base
      # @return [ThinReports::Report::Base]
      # @private
      attr_reader :report

      # @return [Hash]
      # @private
      attr_reader :options
      
      # @private
      def self.inherited(g)
        Generator.register(g.name.split('::').last.downcase.to_sym, g);
      end
      
      # @param [ThinReports::Report::Base] report
      # @param [Hash] options
      def initialize(report, options = {})
        report.finalize
        
        @report  = report.internal
        @options = options || {}
      end
      
      # @return [String]
      # @abstract
      def generate
        raise NotImplementedError
      end
      
      # @param [String] filename
      # @abstract
      def generate_file(filename)
        raise NotImplementedError
      end
      
      # @private
      def default_layout
        report.default_layout
      end      
    end
    
  end
end