# StackView With Floating Item

item を stack-view の row から下にはみ出して配置することができる。

- [Example code](test_feature.rb)
- [Example template file](template.tlf)
- [Example PDF](expect.pdf)

stack-view の row からはみ出して配置した場合でも、その状態を保って描画することができる。
ただし、はみ出す item は「下余白に影響」を無効にしておく必要がある。

「下余白に影響」が有効の場合、row の下余白が負の値となり、意図しない結果となる場合がある。

また、下図の通り、stack-view の高さは、はみ出した item 全体を含んだ高さとなる。

![](images/stack-view-height-with-floting-item.png)
