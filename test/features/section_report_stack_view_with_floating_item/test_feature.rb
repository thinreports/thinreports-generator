# frozen_string_literal: true

require 'feature_test'

class TestSectionReportStackViewWithFloatingItemFeature < FeatureTest
  feature :section_report_stack_view_with_floating_item do
    params = {
      type: :section,
      layout_file: template_path,
      params: {
        groups: [
          {
            details: [
              {
                id: 'detail',
                items: {
                  stackview: {
                    rows: {
                      row1: {
                        items: {
                          textblock: 'short text'
                        }
                      }
                    }
                  }
                }
              },
              {
                id: 'detail',
                items: {
                  stackview: {
                    rows: {
                      row1: {
                        items: {
                          textblock: 'long ' * 19 + 'text'
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

  def image50x50
    StringIO.new(dir.join('50x50.jpg').binread)
  end
end
