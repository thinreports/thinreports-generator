# frozen_string_literal: true

example :section_report, 'section report' do |t|
  params = {
    type: :section,
    layout: t.resource('section_report.tlf'),
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
                image: t.resource('img50x50.png'),
                text: 'ここはページヘッダーです'
              }
            }
          },
          details: (1...11).map { |i| {
            id: :detail,
            items: {
              text: "ここは明細#{i}です。ここは明細#{i}です。ここは明細#{i}です。ここは明細#{i}です。"
            }
          }
          } + [
            {
              id: :detail2,
              items: {
                text: "detail2\ndetail2\ndetail2"
              }
            }
          ] + [
            id: :detail3,
            items: {
              text1: "bar",
              text2: "foo",
              text3: "foobar"
            }
          ] + [
            id: :detail3,
            min_height: 150,
            items: {
              text1: "bar",
              text2: "foo",
              text3: "foobar"
            }
          ] + [
            id: :detail3,
            min_height: 150,
            items: {
              text1: "bar\n" * 10,
              text2: "foo",
              text3: "foobar"
            }
          ],
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
            }
          }
        }
      ]
    }
  }
  Thinreports.generate(params, filename: t.resource('section_report.pdf'))
end
