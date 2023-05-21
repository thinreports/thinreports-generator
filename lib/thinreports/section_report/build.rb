# frozen_string_literal: true

require_relative 'schema/loader'
require_relative 'builder/report_builder'

module Thinreports
  module SectionReport
    class Build
      def call(report_params)
        schema = load_schema(report_params)
        params = report_params[:params] || {}

        Builder::ReportBuilder.new(schema).build(params)
      end

      private

      def load_schema(report_params)
        loader = Schema::Loader.new

        if file = report_params[:layout_file]
          loader.load_from_file(file)
        elsif data = report_params[:layout_data]
          loader.load_from_data(data)
        else
          raise Errors::LayoutFileNotFound
        end
      end
    end
  end
end
