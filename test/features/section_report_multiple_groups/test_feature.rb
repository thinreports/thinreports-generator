# frozen_string_literal: true

require 'feature_test'

class TestSectionReportMultipleGroupsFeature < FeatureTest
  feature :section_report_multiple_groups do
    params = {
      type: :section,
      layout_file: template_path,
      params: {
        groups: [
          {
            headers: {
              header: {
                items: {
                  text: 'Header of Group 1'
                }
              }
            },
            details: 20.times.map {
              {
                id: :detail,
                items: {
                  text: 'Detail of Group 1'
                }
              }
            },
            footers: {
              footer: {
                display: false
              }
            }
          },
          {
            headers: {
              header: {
                items: {
                  text: 'Header of Group 2'
                }
              }
            },
            details: 10.times.map {
              {
                id: :detail,
                items: {
                  text: 'Detail of Group 2'
                }
              }
            }
          }
        ]
      }
    }
    assert_pdf Thinreports.generate(params)
  end
end
