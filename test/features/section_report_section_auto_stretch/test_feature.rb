# frozen_string_literal: true

require 'feature_test'

class TestSectionReportSectionAutoStretchFeature < FeatureTest
  feature :section_report_section_auto_stretch do
    params = {
      type: :section,
      layout_file: template_path,
      params: {
        groups: [
          {
            headers: {
              header1: {
                items: {
                  text_overflow_expand: 'Extended text box height with long text. ' * 3
                }
              },
              header2: {
                items: {
                  text_overflow_expand: 'Extended text box height with long text. ' * 3
                }
              }
            },
            details: [
              {
                id: 'detail1',
                items: {
                  stackview: {
                    rows: {
                      row2: {
                        items: {
                          text_overflow_expand: 'Extended text box height with long text. '
                        }
                      }
                    }
                  }
                }
              },
              {
                id: 'detail2',
                items: {
                  text_overflow_expand: 'Extended text box height with long text. ' * 3
                }
              },
              {
                id: 'detail3',
                items: {
                  stackview: {
                    rows: {
                      row1: {
                        display: false
                      }
                    }
                  }
                }
              }
            ],
            footers: {
              footer1: {
                items: {
                  image200x100: image50x50
                }
              },
              footer2: {
                items: {
                  image200x100: image50x50
                }
              },
              footer3: {
                items: {
                  image200x100: image50x50
                }
              },
              footer4: {
                items: {
                  stackview: {
                    rows: {
                      row2: {
                        display: false
                      }
                    }
                  }
                }
              }
            }
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
