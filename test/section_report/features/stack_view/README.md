# StackView

stack-view によって複数の row を縦に積み重ねたレイアウトを作ることができる。

- [Example code](test_feature.rb)
- [Example template file](template.tlf)
- [Example PDF](expect.pdf)

stack-view の主な機能は以下の通り。

- row は、section 同様、四角形やテキストなどの item をその中にを配置できる
- row はパラメータで動的に非表示にすることも可能。非表示にした row に続く row は、上にスライドして表示される
- stack-view の row の中に、さらに入れ子の stack-view を配置することはできない
