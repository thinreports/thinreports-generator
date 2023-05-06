# frozen_string_literal: true

require 'test_helper'

class Thinreports::SectionReport::TestItemFollowStretchFeature < Thinreports::FeatureTest[__dir__]
  feature do
    params = {
      type: :section,
      layout_file: template_path,
      params: {
        groups: [
          {
            headers: {
              header1: {
                items: {
                  text_expand: "Expand" * 10,
                  text_block: 'Text Block'
                }
              },
              header2: {
                items: {
                  text_expand: "Expand" * 10,
                }
              },
              header3: {
                items: {
                  stackview: {
                    rows: {
                      row1: {
                        items: {
                          text_expand: "Expand" * 10,
                          text_block: 'Text Block'
                        }
                      },
                      row2: {
                        items: {
                          text_expand: "Expand" * 10,
                        }
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
end
