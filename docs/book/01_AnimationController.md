# 01. AnimationController

## AnimationController は何をするオブジェクトか

`AnimationController` は、Flutter の明示的アニメーションにおける **時間軸** です。
多くのアニメーションは「0 から 1 まで進む値」を起点にして作られますが、その進行を管理するのが `AnimationController` です。

## 主な役割

- 現在の進行度を保持する
- `forward()` / `reverse()` / `stop()` などで再生制御する
- 毎フレーム値を更新してリスナーに通知する
- `Animation<double>` として UI 側に値を渡す

## 最小コード

```dart
late AnimationController controller;

@override
void initState() {
  super.initState();
  controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  controller.forward();
}

@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

## よく使うメソッド

| メソッド | 意味 |
|---------|------|
| `forward()` | 正方向に再生 |
| `reverse()` | 逆方向に再生 |
| `stop()` | 現在位置で停止 |
| `reset()` | 初期値へ戻す |
| `repeat()` | 繰り返し再生 |
| `dispose()` | 使用後に破棄 |

## `value` と `status`

- `value`: 現在の数値（通常 0.0〜1.0）
- `status`: `forward` / `reverse` / `completed` / `dismissed`

この 2 つを見ると、**今どこまで進んでいるか** と **どの状態か** を判断できます。

## このリポジトリでの例

`lib/example/my_animation.dart` では、`AnimationController` を `controller` として持ち、`forward()`・`reverse()`・`stop()` をボタンから呼び分けています。

## よくあるミス

### 1. `dispose()` を忘れる

`AnimationController` は内部で `Ticker` を使うため、破棄しないと不要な処理が残ります。

### 2. `forward()` を呼んでいない

コントローラを作っただけでは動きません。`forward()` や `repeat()` などで開始する必要があります。

### 3. `vsync` エラー

`vsync: this` と書くなら、その `State` は `TickerProvider` である必要があります。これは次章で詳しく扱います。

## 理解のポイント

`AnimationController` は「アニメーションそのもの」ではなく、**アニメーションの時間を流す装置**です。
見た目のサイズや色は、この値を `Tween` で変換して初めて決まります。
