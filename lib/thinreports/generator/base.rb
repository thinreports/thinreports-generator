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

      # @param [String, nil] filename
      # @return [String, nil]
      # @abstract
      def generate(filename = nil)
        raise NotImplementedError
      end

      # @private
      def default_layout
        report.default_layout
      end
    end

  end
end
