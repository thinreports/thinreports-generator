require 'bundler'

Bundler.require
require_relative 'lib/thinreports'

params = {
  type: :section,
  layout: 'test.tlf',
  params: {
    start_page_number: 1,
    groups: [
      {
        # headers: {
        #   'document-header': {
        #     items: {
        #       text: 'ここはドキュメントヘッダーです'
        #     }
        #   },
        #   'page-header': {
        #     items: {
        #       text: 'ここはページヘッダーです'
        #     }
        #   }
        # },
        details: [
          {
            id: :detail,
            items: {
              text: 'ここは明細1です'
            }
          },
          {
            id: :detail,
            items: {
              text: 'ここは明細2です'
            }
          },
          {
            id: :detail,
            items: {
              text: 'ここは明細3です'
            }
          }
        ],
        footers: {
        }
      }
    ]
  }
}
Thinreports.generate(params, filename: 'test.pdf')
