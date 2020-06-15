# frozen_string_literal: true

require 'feature_test'

class TestSectionReportTextBlockVerticalAlignFeature < FeatureTest
  feature :section_report_text_block_vertical_align do
    params = {
      type: :section,
      layout_file: template_path,
      params: {
        groups: [
          {
            details: %i(top middle bottom).flat_map { |id|
              [
                {
                  id: id,
                  items: {
                    text: 'short'
                  }
                },
                {
                  id: id,
                  items: {
                    text: 'long' * 20
                  }
                }
              ]
            }
          }
        ]
      }
    }
    assert_pdf Thinreports.generate(params)
  end
end
