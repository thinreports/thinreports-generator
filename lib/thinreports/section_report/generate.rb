# frozen_string_literal: true

require_relative 'build'

module Thinreports
  module SectionReport
    class Generate
      def call(report_params, filename: nil)
        report = Build.new.call(report_params)

        pdf = SectionReport::Pdf::Document.new(report.schema)

        render(pdf, report)

        filename ? pdf.render_file(filename) : pdf.render
      end

      private

      attr_reader :pdf

      def render(pdf, report)
        report.groups.each do |group|
          group.render(pdf)
        end
      end
    end
  end
end
