# Section Parameter

各 section の定義時のプロパティの一部はパラメータで変更することができる。

- [Example code](test_feature.rb)
- [Example template file](template.tlf)
- [Example PDF](expect.pdf)

## 表示

header と footer は `display` プロパティで表示または非表示にすることができる。

```
header_and_footer: {
  display: Boolean
}
```

## 最小の高さ

`min_height` プロパティで section の描画時の最小の高さを指定することができる。

```
header_and_footer: {
  min_height: Number
}
```

```
{
  id: :detail,
  min_height: Number
}
```
