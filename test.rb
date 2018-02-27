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
          'document-header': {
            items: {
              text: 'ここはドキュメントヘッダーです' * 3
            }
          },
          'page-header': {
            items: {
              image: ROOT.join('examples/dynamic_image/img50x50.png')
            }
          }
        },
        details: (1...11).map{|i| {
              id: :detail,
              items: {
                text: "ここは明細#{i}です。ここは明細#{i}です。ここは明細#{i}です。ここは明細#{i}です。"
              }
            }
          },
        footers: {
          'summary-1': {
            items: {
              text: 'ここは合計部1です'
            }
          },
          'summary-2': {
            display: false,
            items: {
              text: 'ここは合計部2です'
            }
          },
          'summary-3': {
            items: {
              text: 'ここは合計部3です' * 3
            }
          },
          'notes': {
            items: {
              text: 'ここは備考1234です'
            }
          },
          'fixed-page-footer': {
            items: {
              text: 'ここは下部固定ページフッターです'
            }
          }
        }
      }
    ]
  }
}
Thinreports.generate(params, filename: 'test.pdf')
