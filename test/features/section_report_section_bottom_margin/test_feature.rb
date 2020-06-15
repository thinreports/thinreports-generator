# frozen_string_literal: true

require 'feature_test'

class TestSectionReportSectionBottomMarginFeature < FeatureTest
  feature :section_report_section_bottom_margin do
    params = {
      type: :section,
      layout_file: template_path,
      params: {
        groups: [
          {
            details: [
              {
                id: :detail,
                items: {
                  textblock: 'short text'
                }
              },
              {
                id: :detail,
                items: {
                  textblock: 'long ' * 19 + 'text'
                }
              }
            ]
          }
        ]
      }
    }
    assert_pdf Thinreports.generate(params)
  end
end
