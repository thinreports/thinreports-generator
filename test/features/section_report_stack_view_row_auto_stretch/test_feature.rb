# frozen_string_literal: true

require 'feature_test'

class TestSectionReportStackViewRowAutoStretchFeature < FeatureTest
  feature :section_report_stack_view_row_auto_stretch do
    params = {
      type: :section,
      layout_file: template_path,
      params: {
        groups: [
          {
            details: [
              {
                id: 'detail1',
                items: {
                  stackview: {
                    rows: {
                      row1: {
                        items: {
                          text_overflow_expand: 'Extended text box height with long text. ' * 4
                        }
                      },
                      row2: {
                        items: {
                          text_overflow_expand: 'Extended text box height with long text. ' * 4
                        }
                      },
                      row3: {
                        items: {
                          text_overflow_expand: 'Extended text box height with long text. ' * 4
                        }
                      }
                    }
                  }
                }
              },
              {
                id: 'detail2',
                items: {
                  stackview: {
                    rows: {
                      row1: {
                        items: {
                          image200x100: image50x50
                        }
                      },
                      row2: {
                        items: {
                          image200x100: image50x50
                        }
                      },
                      row3: {
                        items: {
                          image200x100: image50x50
                        }
                      },
                      row4: {
                        items: {
                          image200x100: image50x50
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
