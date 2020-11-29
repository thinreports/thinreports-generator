# frozen_string_literal: true

require 'feature_test'

class TestSectionReportSectionParametersFeature < FeatureTest
  feature :section_report_section_parameters do
    params = {
      type: :section,
      layout_file: template_path,
      params: {
        groups: [
          {
            headers: {
              header1: {
                display: false
              },
              header2: {
                display: true
              }
            },
            details: [
              {
                id: :detail1_height80,
                min_height: 40
              },
              {
                id: :detail1_height80,
                min_height: 160
              },
              {
                id: :detail2_height100,
                min_height: 100,
                items: {
                  image_block: dir.join('20x20.jpg').to_path
                }
              },
              {
                id: :detail2_height100,
                min_height: 20,
                items: {
                  image_block: dir.join('20x20.jpg').to_path
                }
              },
              {
                id: :detail3_height70,
                min_height: 140,
                items: {
                  text_block: 'text ' * 9
                }
              },
              {
                id: :detail3_height70,
                min_height: 70,
                items: {
                  text_block: 'text ' * 12
                }
              }
            ],
            footers: {
              footer1: {
                display: false
              },
              footer2: {
                display: true
              }
            }
          }
        ]
      }
    }
    assert_pdf Thinreports.generate(params)
  end
end
