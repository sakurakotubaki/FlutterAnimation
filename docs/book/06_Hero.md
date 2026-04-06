# 06. Hero

## Hero は普通の値アニメーションと何が違うのか

`AnimationController`・`Curve`・`Tween` は、主に **同じ画面の中**で値を変化させる仕組みでした。
一方 `Hero` は、**画面をまたいで同じ要素が移動したように見せる**ための仕組みです。

Flutter ではこれを **共有要素遷移** と考えると理解しやすいです。

## Hero の基本ルール

1. 遷移元に `Hero` を置く
2. 遷移先にも `Hero` を置く
3. **両方の `tag` を同じにする**
4. `Navigator.push()` / `pop()` で遷移する

すると Flutter が 2 つの Hero をつなぎ、画面の上を飛ぶようなアニメーションを作ります。

## 最小コード

```dart
Hero(
  tag: coffeeHeroHorizontalTag,
  child: Image.asset('assets/images/coffee.png'),
)
```

ただし実際には、公式サンプルのように `Material` と `InkWell` を組み合わせることが多いです。

## このリポジトリでの例

`lib/example/hero_next.dart` では、次のような構造になっています。

- `CoffeeHeroTile` が `Hero` を持つ
- 一覧画面では左側に小さく表示
- 詳細画面では右側に大きく表示
- `PageRouteBuilder` でページ全体は横スライド
- `Hero` が画像の位置とサイズをつないで見せる

## Hero とページ遷移は別物

ここは特に重要です。

- **ページ全体の動き**: `PageRouteBuilder` / `MaterialPageRoute`
- **共有要素の動き**: `Hero`

つまり、ページをフェードで出しつつ Hero だけ飛ばすこともできますし、横スライドしつつ Hero を拡大することもできます。

## `tag` の考え方

`tag` は Hero 同士を対応づける ID です。

- 文字列でもよい
- モデルオブジェクトでもよい
- 同じ画面で重複しないほうが安全

このリポジトリでは次を使っています。

```dart
const String coffeeHeroHorizontalTag = 'coffee_horizontal';
```

## 公式の考え方との対応

公式ドキュメントでも、Hero は次の 2 点が重要とされています。

- 同じ `tag` を持つペアを作る
- 画面遷移で push / pop すると Flutter が補間する

参考: [Hero animations](https://docs.flutter.dev/ui/animations/hero-animations)

## よくあるミス

### 1. `tag` が一致していない

Hero はつながりません。

### 2. 遷移先に Hero がない

アニメーションされません。

### 3. 画面内に同じ `tag` が複数ある

期待しない動きやエラーの原因になります。

## 理解のポイント

Hero は「画像を拡大する部品」ではなく、
**画面 A にいる要素と画面 B にいる要素を、同じ存在としてつなぐ仕組み**です。

この考え方が分かると、一覧 → 詳細のような UI を自然に設計できるようになります。
