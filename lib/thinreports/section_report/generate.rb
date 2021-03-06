# frozen_string_literal: true

require_relative 'build'
require_relative 'pdf/render'

module Thinreports
  module SectionReport
    class Generate
      def initialize
        @pdf = Thinreports::Generator::PDF::Document.new
      end

      def call(report_params, filename: nil)
        report = Build.new.call(report_params)

        PDF::Render.new(pdf).call!(report)

        filename ? pdf.render_file(filename) : pdf.render
      end

      private

      attr_reader :pdf
    end
  end
end
