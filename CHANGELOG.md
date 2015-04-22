## 0.8.0

This release is a stepping stone to next major version 1.0.0 release.

  * Upgrade to Prawn 1.3 and drop support for Ruby 1.8.7 (#11)
  * Change name of root module to Thinreports from ThinReports (#15)
  * Implement `Item#value=` method (#20)
  * Implement new list callbacks (#17)
  * Implement `page[:item_id]=` as alias for `page.item(:item_id).value=` (#22)
  * Support for setting the default fallback font (#7)
  * Remove `Report#generate_file` method (#13)
  * Deprecate `Report#events`, and implement new callbacks (#18)
  * Deprecate `List#events`, recommend to use `List#on_page_finalize` callback or create manually (#9)

### Upgrade to Prawn 1.3 and drop support for Ruby 1.8.7

We have dropped support for MRI 1.8.7 and 1.8 mode JRuby by upgrading to Prawn 1.3.
Currently supported versions are MRI 1.9.3 and 2.0.0 or higher, JRuby(1.9 mode) 1.7 or higher.

### Change name of root module to Thinreports from ThinReports

We have changed name of root module to `Thinreports` from `ThinReports`.
Old name `ThinReports` has been enabling as alias, but it will be removed
in the next major release.

### Implement `page[:item_id]=` as alias for `page.item(:item_id).value=` (#22)

```ruby
# New setter, same as `page.item(:text_block).value = 'tblock value'`
page[:text_block] = 'tblock value'
# New getter, same as `page.item(:text_block).value`
page[:text_block] # => "tblock value"
page.item(:text_block).value # => "tblock value"

page[:image_block] = '/path/to/image.png'
page[:image_block] # => "/path/to/image.png"
```

See [Issue #22](https://github.com/thinreports/thinreports-generator/issues/22) for further details.

### Implement `Item#value=` method

```ruby
page.item(:text_block).value('value')
page.item(:text_block).value = 'value'
page.item(:image_block).src('/path/to/image.tlf')
page.item(:image_block).src = '/path/to/image.tlf'
```

See [Issue #20](https://github.com/thinreports/thinreports-generator/issues/20) for further details.

### Deprecate `List#events` and `List#store`

`List#events` and `List#store` have been deprecated.

```ruby
report.layout.config.list do |list|
  list.events.on :page_footer_insert do |e|
    # ...
  end
  # => warn: "[DEPRECATION] ..."

  list.events.on :footer_insert do |e|
    # ...
  end
  # => warn: "[DEPRECATION] ..."

  list.events.on :page_finalize do |e|
    # ...
  end
  # => warn: "[DEPRECATION] ..."
end

list.store.price += 0 # => warn: "[DEPRECATION] ..."
```

Please use new callbacks instead:

```ruby
report.list do |list|
  price = 0

  list.on_page_footer_insert do |footer|
    footer.item(:price).value = price
  end

  list.on_footer_insert do |footer|
    # ...
  end

  list.on_page_finalize do
    # ...
  end
end
```

See [Issue #9](https://github.com/thinreports/thinreports-generator/issues/9) and [examples/list_events](https://github.com/thinreports/thinreports-generator/tree/master/examples/list_events) for further details.

### Deprecate `Report#events`, and implement new callbacks

`Report#events` has been deprecated:

```ruby
report.events.on :page_create do |e|
  e.page.item(:text1).value('Text1')
end
# => warn: "[DEPRECATION] ..."

report.events.on :generate do |e|
  e.pages.each do |page|
    page.item(:text2).value('Text2')
  end
end
# => warn: "[DEPRECATION] ..."
```

Please use `Report#on_page_create` callback instead.
However `Report#on_generate` callback has not been implemented,
but you can do the same things using `Report#pages` method.

```ruby
report.on_page_create do |page|
  page.item(:text1).value('Text1')
end

report.pages.each do |page|
  page.item(:text2).value('Text2')
end

report.generate filename: 'foo.pdf'
```

See [Issue #18](https://github.com/thinreports/thinreports-generator/issues/18) for further details.

### Support for setting the default fallback font

Please see [Issue #7](https://github.com/thinreports/thinreports-generator/issues/7) for further details.

## 0.7.7.1

  * No release for generator

## 0.7.7

### Features

  * ページ番号ツール [Katsuya Hidaka]
  * New "Word-wrap" property of TextBlock [Katsuya Hidaka]
  * B4/B5 の ISO サイズを追加 [Takumi FUJISE / Minoru Maeda / Katsuya Hidaka]
  * generate filename: 'foo.pdf' を実装、#generate_file を非推奨へ [Katsuya Hidaka]
  * start_new_page layout: 'file.tlf' でもデフォルトレイアウトが設定されるよう改善 [Eito Katagiri / Katsuya Hidaka]

### Bug fixes

  * Report#use_layout で list の設定を行うとエラーが発生する [Katsuya Hidaka]
  * Layout::Format#page_margin_right が不正な値を返す [Katsuya Hidaka]
  * セキュリティを設定した PDF を印刷すると "このページにはエラーがあります..." メッセージが表示される [Katsuya Hidaka]
  * B4 サイズで出力した PDF の用紙サイズが正しくない [Takumi FUJISE / Katsuya Hidaka]

## 0.7.6

### Features

  * デフォルトレイアウトを書き換え可能へ変更 [Katsuya Hidaka]

### Bug fixes

  * Fix raise NoMethodError when has no default layout [Katsuya Hidaka]

## 0.7.5

### Features

  * テキストブロックのオーバフロープロパティ [Katsuya Hidaka]
  * list メソッドのデフォルト id と Report#list の追加 [Katsuya Hidaka]

### Bug fixes

  * gem install 時にRDoc生成時のエラーが表示される場合がある [Katsuya Hidaka]
  * エディターにて一覧表ツールのヘッダーを使わない場合の動作について [吉田 和弘 / Katsuya Hidaka]

## 0.7.0

### Features

  * Listに :page_finalize イベントを追加
  * ダイナミックスタイルの拡充
  * イメージブロックの実装
  * Tblockで行間、横位置、縦位置、文字間隔の指定を可能に
  * Prawn 0.12.0 を採用
  * メタ情報のタイトルに反映
  * Example Test環境の構築
  * 外字の埋め込みサポート
  * clean taskの削除
  * YARD Docのテンプレート追加
  * ロードするprawnのバージョンを固定
  * .generate, .generate_fileメソッドのオプション指定をフラット化
  * 単行モードテキストブロックがレイアウトで定義した「高さ」の影響を受けないように
  * PXD形式の出力フォーマット廃止とデフォルトタイプの導入
  * $KCODEによる文字カウント処理の改善
  * List#headerの挙動を改善
  * Errors::UnknownItemId 時のエラーメッセージを分かりやすく
  * テスト漏れに対するテストコード作成とテスト

### Bug fixes

  * フッターが挿入時、リスト領域をオーバフローしない場合でも改ページされる場合がある
  * Tblockで基本書式のみ設定されている場合、その書式が反映されない
  * Tblockがフォントサイズに対して小さすぎる場合にエラー
