# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Schema
      class Report < Core::Shape::Manager::Format
        config_reader last_version: %w( version )
        config_reader report_title: %w( title )
        config_reader page_paper_type: %w( report paper-type ),
                      page_orientation: %w( report orientation ),
                      page_margin: %w( report margin ),
                      page_width: %w[report width],
                      page_height: %w[report height]

        attr_reader :headers, :details, :footers

        def user_paper_type?
          page_paper_type == 'user'
        end

        def initialize(schema_data, headers:, details:, footers:)
          super(schema_data)
          @headers = headers
          @details = details
          @footers = footers
        end
      end
    end
  end
end
