# 02. Ticker と Vsync

## なぜ `vsync` が必要なのか

`AnimationController` を作るとき、Flutter では通常 `vsync` を要求されます。
これは、アニメーションを **画面の描画タイミングに同期**させるためです。

## Ticker とは

`Ticker` は、フレームごとに時間の経過を通知する仕組みです。
`AnimationController` はこの `Ticker` を使って、毎フレーム `value` を更新します。

## Vsync とは

Vsync はディスプレイの更新周期と描画を合わせる考え方です。
Flutter では、必要なときだけアニメーションを動かし、不要なときは無駄な更新を避けるために `vsync` を使います。

## `TickerProvider` の役割

`TickerProvider` は `Ticker` を提供するオブジェクトです。
`AnimationController` は `vsync` に `TickerProvider` を受け取り、内部で `Ticker` を作ります。

## よく使うミックスイン

```dart
class _MyAnimationState extends State<MyAnimation>
    with SingleTickerProviderStateMixin {
}
```

### 使い分け

| ミックスイン | 用途 |
|-------------|------|
| `SingleTickerProviderStateMixin` | コントローラが 1 つ |
| `TickerProviderStateMixin` | コントローラが複数 |

## よくあるエラー

### エラー例

```dart
The argument type '_LogoAppState' can't be assigned to the parameter type 'TickerProvider'.
```

### 原因

`State` が `TickerProvider` になっていないのに、`vsync: this` を書いているためです。

### 修正方針

- `with SingleTickerProviderStateMixin` を付ける
- もしくは複数なら `TickerProviderStateMixin` を使う

## このリポジトリでの例

- `lib/example/logo_app.dart`
- `lib/example/my_animation.dart`

どちらも `State` に `SingleTickerProviderStateMixin` を付けて `vsync: this` を成立させています。

## 理解のポイント

`vsync` は単なるおまじないではありません。
**「このアニメーションは画面描画と同期して動くべきです」** と Flutter に伝えるための重要な情報です。
