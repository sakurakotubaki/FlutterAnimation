# 04. Tween

## Tween の役割

`AnimationController` の値は通常 `0.0`〜`1.0` です。
しかし実際の UI では、幅 `0`〜`300`、不透明度 `0.1`〜`1.0`、位置 `Offset(1, 0)`〜`Offset.zero` のような値が必要です。

この **0〜1 の進行度を、表示に必要な値へ変換する** のが `Tween` です。

## 例: サイズを変える

```dart
static final _sizeTween = Tween<double>(begin: 0, end: 300);

@override
Widget build(BuildContext context) {
  final animation = listenable as Animation<double>;
  return Container(
    width: _sizeTween.evaluate(animation),
    height: _sizeTween.evaluate(animation),
  );
}
```

このリポジトリでは `lib/example/my_animation.dart` に同じ考え方があります。

## `evaluate` と `animate`

### `evaluate(animation)`

- 毎回その場で値を取り出す
- シンプルで理解しやすい

### `animate(parent)`

- `Tween` を `Animation<T>` に変換する
- 他のアニメーションウィジェットに渡しやすい

```dart
final animation = Tween<double>(begin: 0, end: 300).animate(controller);
```

## よく使う Tween

| クラス | 用途 |
|--------|------|
| `Tween<double>` | サイズ、不透明度、角丸半径など |
| `ColorTween` | 色 |
| `Tween<Offset>` | スライド位置 |
| `RectTween` | 矩形の変化 |
| `IntTween` | 整数カウンタ |

## Hero と RectTween

`Hero` は内部で矩形の位置や大きさを補間します。
そのため `Tween` の考え方は、通常のサイズ変更だけでなく、**画面間の移動**を理解するうえでも重要です。

## よくある誤解

### `Tween` だけでは動かない

`Tween` は「変換ルール」です。
実際に時間が進むのは `AnimationController` で、`Tween` はその値を使って結果を返しているだけです。

### begin と end を変えても自動では更新されない

`Tween` はあくまでオブジェクトです。再描画と組み合わせて使って初めて画面に反映されます。

## 理解のポイント

`Tween` を理解すると、Flutter アニメーションの多くは
**「0〜1 をどう使って表現したい値に変えるか」** の問題に見えてきます。
