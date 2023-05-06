# TextBlock Vertical-align Support

section-report 形式の text-block は `overflow: expand` のときの縦揃え(中央、下揃え)をサポートする。

- [Example code](test_feature.rb)
- [Example template file](template.tlf)
- [Example PDF](expect.pdf)

通常の形式の text-block は、`overflow: expand` で縦位置が中央又は下揃えのとき意図通りに描画されない。これは prawn の仕様によるものである。

section-report 形式では、これを独自にサポートしている。
