# frozen_string_literal: true

require 'feature_test'

class TestSectionReportStackViewRowParametersFeature < FeatureTest
  feature :section_report_stack_view_row_parameters do
    params = {
      type: :section,
      layout_file: template_path,
      params: {
        groups: [
          {
            headers: {
              header: {
                items: {
                  stackview1: {
                    rows: {
                      row1: {
                        display: false
                      },
                      row2: {
                        display: true
                      }
                    }
                  }
                }
              }
            },
            details: [
              {
                id: :detail,
                items: {
                  stackview2: {
                    rows: {
                      row1: {
                        min_height: 10
                      },
                      row2: {
                        min_height: 70
                      },
                      row3: {
                        min_height: 90,
                        items: {
                          image_block: dir.join('20x20.jpg').to_path
                        }
                      },
                      row4: {
                        min_height: 20,
                        items: {
                          image_block: dir.join('20x20.jpg').to_path
                        }
                      },
                      row5: {
                        min_height: 140,
                        items: {
                          text_block: 'text ' * 9
                        }
                      },
                      row6: {
                        min_height: 55,
                        items: {
                          text_block: 'text ' * 16
                        }
                      }
                    }
                  }
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
