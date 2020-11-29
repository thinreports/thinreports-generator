# Section Auto Stretch

自動伸縮を有効にすることで、描画後の内容に応じて section の高さを自動的に伸縮させることができる。

- [Example code](test_feature.rb)
- [Example template file](template.tlf)
- [Example PDF](expect.pdf)

## 伸縮時の高さの算出

### 下余白とコンテンツの下位置

section の伸縮後の高さは「下余白」と「コンテンツの下位置」によって決定する。

コンテンツの下位置
- section 内の item の最下部の位置を指す (「下余白に影響」が無効の item は除外)
- 描画結果によって変動する

下余白
- コンテンツの下位置から section の下位置との距離又は領域を指す
- 定義時の内容で決定し不変

詳細は [Section Bottom Margin](../section_report_section_bottom_margin/README.md) を参照。

### 高さの算出

section の高さは次のように定義する。

```
section の高さ = コンテンツの下位置 + 下余白の高さ
```

text-block や stack-view などの item が伸縮した場合、コンテンツの下位置が変動する可能性がある。sectionの自動伸縮が有効な場合、その変動後のコンテンツの下位置に基づいてsectionの高さが変化する。

## 拡張

高さの拡張は以下の条件によって発生する。

- text-block の描画後の高さが定義の高さよりも高くなり、その結果 section のコンテンツの下位置が大きくなる場合
- stack-view の描画後の高さが定義の高さよりも高くなり、その結果 section のコンテンツの下位置が大きくなる場合

このとき、section は以下のように拡張する。

![](images/auto-stretch-expand.png)

## 縮小

高さの縮小は以下の条件によって発生する。

- stack-view の高さが定義の高さよりも小さくなり、その結果 section のコンテンツの下位置が小さくなる場合
- 縦位置が「上揃え」の image-block の画像が定義した領域の高さよりも小さくなり、その結果 section のコンテンツの下位置が小さくなる場合

このとき、section は以下のように縮小する。

![](images/auto-stretch-shrink.png)
