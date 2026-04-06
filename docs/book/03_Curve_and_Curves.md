# 03. Curve と Curves

## Curve は何を変えるのか

`AnimationController` の `value` は、基本的には時間に対して素直に進みます。
しかし、現実の動きは等速ではないことが多く、最初はゆっくり、途中で速く、最後にまたゆっくり止まることが自然に見えます。

この「進み方の形」を決めるのが `Curve` です。

## `Curves` は定義済みのカーブ集

Flutter には便利なカーブが最初から用意されています。

| カーブ | 印象 |
|--------|------|
| `Curves.linear` | 等速 |
| `Curves.easeIn` | はじめゆっくり、後半で加速 |
| `Curves.easeOut` | はじめ速く、最後ゆっくり |
| `Curves.easeInOut` | 両端がゆっくり |
| `Curves.easeOutCubic` | よりなめらかな減速 |
| `Curves.bounceOut` | 跳ねるような終わり方 |

## `CurvedAnimation`

カーブを適用したいときは、`AnimationController` を `CurvedAnimation` で包みます。

```dart
late Animation<double> animation;

animation = CurvedAnimation(
  parent: controller,
  curve: Curves.easeIn,
);
```

## `reverseCurve`

往復アニメーションでは、戻るときだけ別のカーブを使いたいことがあります。
そのときは `reverseCurve` を指定します。

```dart
final curved = CurvedAnimation(
  parent: controller,
  curve: Curves.easeOutCubic,
  reverseCurve: Curves.easeInCubic,
);
```

これは `lib/example/hero_next.dart` の画面遷移でも使っています。

## カーブが必要な理由

同じ 1 秒のアニメーションでも、カーブを変えるだけで印象は大きく変わります。

- 線形: 機械的
- easeIn: これから動き出す感じ
- easeOut: 着地・収束する感じ
- easeInOut: UI アニメーションで自然に見えやすい

## よくある誤解

### `Curve` が値を作っているのではない

`Curve` は **進行度の形を変える** だけです。
サイズや色そのものを決めるのは `Tween` です。

### `Curves` はクラス名

`Curves.easeIn` のように使う `Curves` は、よく使う `Curve` を集めた定数集です。

## 理解のポイント

- `AnimationController`: 時間を進める
- `Curve`: 進み方を変える
- `Tween`: 値に変換する

この 3 つを別の役割として覚えると混乱しにくくなります。
