# frozen_string_literal: true

require 'test_helper'

class Thinreports::SectionReport::TestStackViewFeature < Thinreports::FeatureTest[__dir__]
  feature do
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
                  stackview1: {
                    rows: {
                      row2: {
                        items: {
                          text: 'text block'
                        }
                      }
                    }
                  },
                  stackview2: {
                    rows: {
                      row2: {
                        display: false
                      },
                      row3: {
                        display: false
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
