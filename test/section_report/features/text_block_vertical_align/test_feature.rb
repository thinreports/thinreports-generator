# frozen_string_literal: true

require 'test_helper'

class Thinreports::SectionReport::TestTextBlockVerticalAlignFeature < Thinreports::FeatureTest[__dir__]
  feature do
    params = {
      type: :section,
      layout_file: template_path,
      params: {
        groups: [
          {
            details: %i(top middle bottom).flat_map { |id|
              [
                {
                  id: id,
                  items: {
                    text: 'short'
                  }
                },
                {
                  id: id,
                  items: {
                    text: 'long' * 20
                  }
                }
              ]
            }
          }
        ]
      }
    }
    assert_pdf Thinreports.generate(params)
  end
end
