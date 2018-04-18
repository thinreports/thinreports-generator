# frozen_string_literal: true

example :stack_view_in_section_report, 'stack view in section report' do |t|
  params = {
    type: :section,
    layout_file: t.resource('stack_view_in_section_report.tlf'),
    params: {
      start_page_number: 1,
      groups: [
        {
          headers: {
            "document-header": {
              items: {
                stack_view_left: {
                  rows: {
                    top_row: {
                      items: {
                        test_text: "top row\n" * 15
                      }
                    },
                    bottom_row: {
                      items: {
                        child_stack_view: {
                          rows: {
                            child_top_row: {
                              items: {
                                test_text: "child top row"
                              }
                            },
                            child_middle_row: {
                              display: false
                            },
                            child_bottom_row: {
                              items: {
                                test_text: "child bottom row\n" * 3
                              }
                            }
                          }
                        },
                        child_image: t.resource('img50x50.png')
                      }
                    }
                  }
                },
                stack_view_right: {
                  rows: {
                    top_row: {
                      items: {
                        test_text: 'top row'
                      }
                    },
                    bottom_row: {
                      items: {
                        test_text: 'bottom row'
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
  Thinreports.generate(params, filename: t.resource('stack_view_in_section_report.pdf'))
end
