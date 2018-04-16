# frozen_string_literal: true
require 'bundler'
require 'pathname'

Bundler.require
require_relative 'lib/thinreports'

ROOT = Pathname.new File.expand_path('..', __FILE__)

params = {
  type: :section,
  layout: 'test.tlf',
  params: {
    start_page_number: 1,
    groups: [
      {
        headers: {
          "document-header": {
            items: {
              sender_info_view_left: {
                display: true,
                top_row: {
                  display: true,
                  items: {
                    test_text: "foo\n" * 15
                  }
                },
                bottom_row: {
                  display: true,
                  items: {
                    child_stack_view: {
                      display: true,
                      child_top_row: {
                        display: true,
                        items: {
                          test_text: "child_foo"
                        }
                      },
                      child_middle_row: {
                        display: false
                      },
                      child_bottom_row: {
                        display: true,
                        items: {
                          test_text: "child_bar\n" * 1
                        }
                      }
                    },
                    child_image: ROOT.join('examples/dynamic_image/img50x50.png')
                  }
                }
              },
              sender_info_view_right: {
                display: true,
                top_row: {
                  display: true,
                  items: {
                    test_text: 'foo'
                  }
                },
                bottom_row: {
                  display: true,
                  items: {
                    test_text: 'hoge'
                  }
                }
              },
              test_text3: "foo3"
            }
          }
        }
      }
    ]
  }
}
Thinreports.generate(params, filename: 'test.pdf')