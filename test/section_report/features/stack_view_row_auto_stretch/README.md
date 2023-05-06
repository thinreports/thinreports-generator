# StackViewRow Auto Stretch

自動伸縮を有効にすることで、描画後の内容に応じて row の高さを自動的に伸縮させることができる。

- [Example code](test_feature.rb)
- [Example template file](template.tlf)
- [Example PDF](expect.pdf)

row の伸縮によって stack-view 自体の高さも伸縮する。
row の伸縮の仕様は section と同様である。詳細は [Section Auto Stretch](../section_report_section_auto_stretch/README.md) を参照。
ただし、stack-view は入れ子にすることはできないため、stack-view によるrowの伸縮は起こらない。
