# frozen_string_literal: true

require 'feature_test'

class TestSectionReportItemParametersFeature < FeatureTest
  feature :section_report_item_parameters do
    params = {
      type: :section,
      layout_file: template_path,
      params: {
        groups: [
          {
            details: [
              {
                id: :detail1,
                items: {
                  image_block: image_block_jpg.to_path
                }
              },
              {
                id: :detail1,
                items: {
                  text: {
                    styles: {
                      font_size: 24,
                      align: :center,
                      valign: :middle,
                      color: '#ff0000',
                      bold: true,
                      italic: true,
                      underline: true,
                      linethrough: true
                    }
                  },
                  text_block: {
                    styles: {
                      font_size: 24,
                      align: :right,
                      valign: :bottom,
                      color: 'black',
                      bold: false,
                      italic: false,
                      underline: false,
                      linethrough: false
                    }
                  },
                  image_block: image_block_jpg.to_path
                }
              },
              {
                id: :detail1,
                items: {
                  image_block: {
                    value: image_block_jpg.to_path,
                    styles: {
                      offset_x: 20,
                      offset_y: -20
                    }
                  }
                }
              },
              {
                id: :detail1,
                items: {
                  rect: {
                    display: false
                  },
                  ellipse: {
                    display: false
                  },
                  text: {
                    display: false
                  },
                  line: {
                    display: false
                  },
                  image: {
                    display: false
                  },
                  text_block: {
                    display: false
                  },
                  image_block: {
                    display: false
                  },
                  stackview: {
                    display: false
                  }
                }
              },
              {
                id: :detail2,
                items: {
                  text_block1: 'text-block1',
                  text_block2: {
                    value: 'text-block2'
                  },
                  image_block1: image_block_jpg.to_path,
                  image_block2: StringIO.new(image_block_jpg.binread),
                  image_block3: {
                    value: image_block_jpg.to_path,
                  },
                  image_block4: {
                    value: StringIO.new(image_block_jpg.binread)
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

  private

  def image_block_jpg
    dir.join('image-block.jpg')
  end
end
