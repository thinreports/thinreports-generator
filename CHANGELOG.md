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
