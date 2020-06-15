# Basic

section-report 形式では、ヘッダー・フッター・繰り返し行の3つの種類のセクションを複数定義でき、それらを組み合わせた PDF を生成することができる。

- [Example code](test_feature.rb)
- [Example template file](template.tlf)
- [Example PDF](expect.pdf)

## セクション

ヘッダー `headers`

- 複数定義できる
- テンプレートで定義した順に描画される
- パラメータで非表示にすることもできる
- "毎ページ表示" が有効なら毎ページ、そうでなければ最初のページに描画される (厳密にはパラメータグループごとに最初のページに描画)

フッター `footers`

- 複数定義できる
- テンプレートで定義した順に描画される
- パラメータで非表示にすることもできる

繰り返し行 `details`

- 複数定義できる
- パラメータで追加した順で描画される
- 繰り返し行の `id` を指定して追加することで、複数の行を組み合わせて描画することができる

## 改ページ

ページに入り切らないセクションは、次のページに描画される。

## PDF の生成

次のようなパラメータを `Thinreports.generate` に渡すことで PDF を生成する。

```ruby
params = {
  type: :section,
  layout_file: '/path/to/template.tlf',
  params: {
    groups: [
      {
        headers: {
          any_header_id: {
            items: {
              logo_image: '/path/to/logo.jpg'
            }
          }
        },
        details: [
          {
            id: 'detail_id',
            items: {
              name_field_id: 'field value'
            }
          }
        ],
        footers: {
          any_footer_id: {
            display: false
          }
        }
      }
    ]
  }
}

Thinreports.generate(params, filename: '/path/to/output.pdf')
```

PDF データを取得する場合は `filename` を省略する。

```ruby
Thinreports.generate(params) #=> PDF data
```
