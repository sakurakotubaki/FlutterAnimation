# 05. AnimatedWidget と AnimatedBuilder

## UI へどう反映するか

ここまでで、`AnimationController` が時間を進め、`Curve` が進み方を変え、`Tween` が値を変換することを見てきました。
では、その値を **どうやって画面に反映するか** が次のテーマです。

その代表が `AnimatedWidget` と `AnimatedBuilder` です。

## AnimatedWidget

`AnimatedWidget` は、`Listenable` の変更に応じて自動で再描画される基底クラスです。

```dart
class MyAnimatedImage extends AnimatedWidget {
  const MyAnimatedImage({super.key, required Animation<double> animation})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Opacity(
      opacity: Tween<double>(begin: 0.1, end: 1).evaluate(animation),
      child: const FlutterLogo(),
    );
  }
}
```

### 長所

- `setState()` を自分で書かなくてよい
- 再利用しやすい
- ロジックがウィジェットにまとまりやすい

### 向いているケース

- アニメーションの描画部品を 1 つのウィジェットとして切り出したいとき
- 今回の `AnimatedLogo` や `MyAnimatedImage` のようなケース

## AnimatedBuilder

`AnimatedBuilder` は、アニメーションと `builder` 関数を渡して UI を更新する仕組みです。

```dart
AnimatedBuilder(
  animation: controller,
  builder: (context, child) {
    return Transform.scale(
      scale: controller.value,
      child: child,
    );
  },
  child: const FlutterLogo(),
)
```

### 長所

- 一部の UI だけを再構築しやすい
- `child` を再利用して無駄な生成を減らせる
- 既存ウィジェットの近くにアニメーション処理を書きやすい

## 使い分け

| 項目 | AnimatedWidget | AnimatedBuilder |
|------|----------------|-----------------|
| 再利用 | しやすい | その場向き |
| 記述場所 | クラスとして分離 | ビルド内で完結 |
| `child` 最適化 | 自分で設計 | しやすい |
| 学習コスト | 少し高い | 比較的直感的 |

## 手書き `addListener + setState` との違い

昔ながらの書き方では、`addListener(() => setState(() {}))` として毎フレーム再描画します。
これは仕組みを理解するには良いですが、実務では `AnimatedWidget` や `AnimatedBuilder` のほうが整理しやすいことが多いです。

## このリポジトリでの例

- `lib/example/logo_app.dart`: `AnimatedLogo`
- `lib/example/my_animation.dart`: `MyAnimatedImage`

どちらも `AnimatedWidget` を使い、`listenable` を `Animation<double>` として受け取っています。

## 理解のポイント

Flutter アニメーションは「値を作ること」と「UI に反映すること」を分けて考えると整理しやすいです。
`AnimatedWidget` と `AnimatedBuilder` は、その後半を担当するオブジェクトです。
