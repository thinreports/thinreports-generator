# Item Paramater

各item の定義時のスタイルやプロパティはパラメータで変更することができる。

- [Example code](test_feature.rb)
- [Example template file](template.tlf)
- [Example PDF](expect.pdf)

変更できるスタイルやプロパティは item の種類によって異なる。

## 共通

```
all_item: {
  display: Boolean, # 表示状態を変更する
}
```

## テキストスタイル

```
text_block_and_text_item: {
  styles: {
    font_size: Number, # フォントサイズを変更する
    align: :left | :center | :right, # 水平方向の位置揃えを変更する
    valign: :top | :middle | :bottom, # 垂直方向の位置揃えを変更する
    color: String, # テキストカラーを変更する
    bold: Boolean, # 太字スタイルを変更する
    italic: Boolean, # 斜体スタイルを変更する
    linethrough: Boolean # 取消線スタイルを変更する
  }
}
```

## 位置の移動

```
image_block_item: {
  styles: {
    offset_x: Number, # 水平方向に移動する
    offset_y: Number # 垂直方向に移動する
  }
}
```

## 値をセットする

```
text_block_item: {
  value: 'text value'
},
text_block_item: 'text value'
```

```
image_block_item: {
  value: '/path/to/image.jpg'
},
image_block_item: {
  value: StringIO.new(File.binread('/path/to/image.jpg'))
},
image_block_item: '/path/to/image.png',
image_block_item: StringIO.new(File.binread('/path/to/image.png'))
```
