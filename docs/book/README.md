# Flutter Animation 学習本 章構成

このディレクトリは、Flutter アニメーションを段階的に学ぶための章ファイル群です。
既存の `docs/ANIMATION.md` は全体像、`docs/OBJECT.md` は辞書的な詳解として残し、ここでは **学習順** を意識した構成にしています。

## 読み順

1. [`00_学習ガイド.md`](./00_学習ガイド.md)
2. [`01_AnimationController.md`](./01_AnimationController.md)
3. [`02_Ticker_and_Vsync.md`](./02_Ticker_and_Vsync.md)
4. [`03_Curve_and_Curves.md`](./03_Curve_and_Curves.md)
5. [`04_Tween.md`](./04_Tween.md)
6. [`05_AnimatedWidget_and_AnimatedBuilder.md`](./05_AnimatedWidget_and_AnimatedBuilder.md)
7. [`06_Hero.md`](./06_Hero.md)

## この章構成の狙い

- **動く理由** を先に理解する
- **コードの書き方** をあとから整理する
- **画面遷移アニメーション** までつなげて理解する
- プロジェクト内のサンプルコードと対応づけながら学べるようにする

## 対応するサンプル

- `lib/example/logo_app.dart`
- `lib/example/my_animation.dart`
- `lib/example/hero_next.dart`
- `lib/example/hero_animation_widget.dart`

## 補助資料

- [`../ANIMATION.md`](../ANIMATION.md): スライド形式の概要
- [`../OBJECT.md`](../OBJECT.md): オブジェクト中心の詳解
