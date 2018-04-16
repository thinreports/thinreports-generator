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
            min_height: 150,
            items: {
              text1: "bar\n" * 10,
              text2: "foo\nfoo",
              text3: "foobar\nfoobar"
            }
          }
        }
      }
    ]
  }
}
Thinreports.generate(params, filename: 'test.pdf')
