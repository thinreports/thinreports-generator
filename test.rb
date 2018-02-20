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
        headers: {
          'document-header': {
            items: {
              text: 'ここはドキュメントヘッダーです'
            }
          },
          'page-header': {
            items: {
              text: 'ここはページヘッダーです'
            }
          }
        },
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
          'summary-1': {
            items: {
              text: 'ここは合計部1です'
            }
          },
          'summary-2': {
            items: {
              text: 'ここは合計部2です'
            }
          },
          'summary-3': {
            items: {
              text: 'ここは合計部3です'
            }
          },
          'notes': {
            items: {
              text: 'ここは備考です'
            }
          },
          'misoca-logo': {
            items: {
              text: 'ここはMisocaロゴです'
            }
          }
        }
      }
    ]
  }
}
Thinreports.generate(params, filename: 'test.pdf')
