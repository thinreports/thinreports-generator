module Thinreports
  module SectionReport
    module Schema
      class Report < Core::Shape::Manager::Format
        config_reader last_version: %w( version )
        config_reader report_title: %w( title )
        config_reader page_paper_type: %w( report paper-type ),
                      page_orientation: %w( report orientation ),
                      page_margin: %w( report margin )

        attr_reader :headers, :details, :footers

        def page_margin_top
          page_margin[0]
        end

        def page_margin_bottom
          page_margin[2]
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
