# frozen_string_literal: true

require 'test_helper'

class Thinreports::SectionReport::TestSectionBottomMarginFeature < Thinreports::FeatureTest[__dir__]
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
