# frozen_string_literal: true

require 'test_helper'

class Thinreports::SectionReport::TestStackViewWithFloatingItemFeature < Thinreports::FeatureTest[__dir__]
  feature do
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
