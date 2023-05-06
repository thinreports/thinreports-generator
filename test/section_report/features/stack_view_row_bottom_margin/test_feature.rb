# frozen_string_literal: true

require 'test_helper'

class Thinreports::SectionReport::TestStackViewRowBottomMarginFeature < Thinreports::FeatureTest[__dir__]
  feature do
    params = {
      type: :section,
      layout_file: template_path,
      params: {
        groups: [
          {
            headers: {
              header: {
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
            }
          }
        ]
      }
    }
    assert_pdf Thinreports.generate(params)
  end
end
