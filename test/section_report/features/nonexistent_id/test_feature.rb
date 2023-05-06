# frozen_string_literal: true

require 'test_helper'

class Thinreports::SectionReport::TestNonExistentIdFeature < Thinreports::FeatureTest[__dir__]
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
                  text: 'text',
                  nonexistent_item: 'nonexistent items are ignored'
                }
              },
              nonexistent_header: {
                items: {
                  any_item: 'nonexistent sections and items within them are ignored'
                }
              }
            },
            details: [
              {
                id: 'detail',
                items: {
                  text: 'text',
                  nonexistent_item: 'nonexistent items are ignored',
                  stackview: {
                    rows: {
                      row1: {
                        items: {
                          text: 'text',
                          nonexistent_item: 'nonexistent items are ignored',
                        }
                      },
                      nonexistent_row: {
                        items: {
                          any_item: 'nonexistent rows and items within them are ignored'
                        }
                      }
                    }
                  }
                }
              },
              {
                id: 'nonexistent_detail',
                items: {
                  any_item: 'nonexistent sections and items within them are ignored'
                }
              }
            ],
            footers: {
              footer: {
                items: {
                  text: 'text',
                  nonexistent_item: 'nonexistent items are ignored'
                }
              },
              nonexistent_footer: {
                items: {
                  any_item: 'nonexistent sections and items within them are ignored'
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
