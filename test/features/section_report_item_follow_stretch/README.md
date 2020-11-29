# Item Follow Stretch

領域伸縮に追従を有効にすることで、配置された section 又は stack-view-row の伸縮に応じて、item の高さや位置を自動的に変化させることができる。

- [Example code](test_feature.rb)
- [Example template file](template.tlf)
- [Example PDF](expect.pdf)


それぞれのオプションと伸縮による変化は次の通り。

## 領域伸縮に追従: 高さ `follow-stretch: height`

領域の伸縮によって、item の高さが伸縮する。

以下の item をサポート:

- text-block
- text
- rect
- line

## 領域伸縮に追従: 上位置 `follow-stretch: y`

領域の伸縮によって、item の上位置が移動する。

以下の item をサポート:

- line

## 領域伸縮に追従: なし (デフォルト) `follow-stretch: none`

領域の伸縮の影響を受けない
