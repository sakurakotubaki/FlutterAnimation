# Flutter アニメーションで使うオブジェクト（詳解）

このドキュメントは、**明示的アニメーション（Explicit animations）** を組み立てるときに登場するクラス・ミックスイン・概念を、役割と関係性に沿って整理したものです。公式の入門は [Introduction to animations](https://docs.flutter.dev/ui/animations) を参照してください。

---

## 1. 全体の依存関係（ざっくり）

データの流れは次のイメージです。

1. **`TickerProvider`** が **`Ticker`**（毎フレームの刻み）を提供する  
2. **`AnimationController`** が時間を進め、`0.0`〜`1.0` 付近の値を更新する  
3. 必要なら **`Curve` / `CurvedAnimation`** で進み方を非線形にする  
4. **`Tween`** が「コントローラの進行度」→「表示に使う値（サイズ・色など）」に写す  
5. **`Animation<T>`** としてウィジェット側に渡し、**`Listenable`** の通知で **`build` が再実行**される  

**ルート遷移に限った話**として、画面間で見た目をつなぐ **`Hero`** は別系統です（後述）。

---

## 2. `Ticker` と `TickerProvider`

### `Ticker` とは

- **ディスプレイの垂直同期（VSync）に合わせて**、短い間隔でコールバックを呼ぶ仕組みです。  
- `AnimationController` は内部で `Ticker` を使い、**フレームのタイミングで値を更新**します。  
- そのため、アニメーションは「CPU が空いているから速く回る」のではなく、**描画レートに同期**します。

### `TickerProvider` とは

- **`Ticker` を作成する工場**のような役割のインターフェースです。  
- `AnimationController` のコンストラクタ **`vsync`** に渡すのが、この `TickerProvider` です。

### `SingleTickerProviderStateMixin` / `TickerProviderStateMixin`

| 名前 | 用途 |
|------|------|
| **`SingleTickerProviderStateMixin`** | この `State` から **`AnimationController` を 1 本** 作るときに使う。`vsync: this` の `this` が `TickerProvider` になる。 |
| **`TickerProviderStateMixin`** | **複数**の `AnimationController`（または複数 `Ticker`）が必要なとき。 |

**よくあるエラー**：`vsync: this` と書いたのに `TickerProvider` ではない → **上記ミックスインを `State` に付けていない**ことが原因です。

---

## 3. `AnimationController`

### 役割

- **進行度**（通常 **`lowerBound`〜`upperBound`**、デフォルトは `0.0`〜`1.0`）を時間とともに変化させる。  
- **`Animation<double>` としても振る舞う**（`AnimationController` は `Animation<double>` を継承）。  
- 再生制御（`forward` / `reverse` / `stop` / `reset` / `repeat` など）の API を持つ。

### 主なプロパティ・概念

| 項目 | 説明 |
|------|------|
| **`duration`** | `forward` などで **0→1（に相当する方向）** に進むのに要する時間。 |
| **`reverseDuration`** | 逆方向に専用の長さを付けたいとき。 |
| **`value`** | 現在の値（通常 0〜1）。 |
| **`status`** | `AnimationStatus`（`dismissed` / `forward` / `reverse` / `completed` など）。 |

### ライフサイクル

- **`State` で保持する場合は `dispose` で必ず `controller.dispose()`** する。  
- 破棄しないと **`Ticker` やリスナーが残り**、メモリリークや不要な再描画の原因になります。

### コード上の位置づけ

このリポジトリでは `lib/example/logo_app.dart` や `lib/example/my_animation.dart` で、`initState` で生成して `forward()` し、`dispose` で破棄するパターンになっています。

---

## 4. `Animation<T>`（抽象クラス）

### 役割

- **時間とともに変化する値**を表す。`T` は `double`・`Color`・`Rect`・`Offset` など。  
- **`Listenable` を実装**しており、値が変わるとリスナーに通知される。  
- UI 側は「今の `value`（または `Tween` 経由の評価結果）を読んで描画する」だけにできる。

### よく使う API

| API | 説明 |
|-----|------|
| **`value`** | 現在値（型は `T`）。 |
| **`addListener`** / **`removeListener`** | 値が変わるたびに `setState` などを呼ぶために使う（`AnimatedBuilder` はこれを内包）。 |
| **`addStatusListener`** | `completed` / `dismissed` など **状態変化**のとき（ループや逆再生の切り替えに使う）。 |

### `AnimationController` との関係

- **`AnimationController` 自体が `Animation<double>`** なので、そのまま子に渡して **0〜1** をアニメーションさせられる。  
- 表示用の値（例：幅 0〜300）にしたいときは **`Tween` で包む**か、`Tween.evaluate(animation)` で都度評価する。

---

## 5. `AnimationStatus`

`Animation` / `AnimationController` の **論理的な段階**を表します。

| 値 | 意味の目安 |
|----|------------|
| **`dismissed`** | 下限側にいる（多くの場合「逆再生が終わった」）。 |
| **`forward`** | 進行中（正方向）。 |
| **`reverse`** | 進行中（逆方向）。 |
| **`completed`** | 上限に達した。 |

**`addStatusListener`** で `completed` を見て `reverse()`、`dismissed` を見て `forward()` とすると、**往復ループ**を書けます（`my_animation.dart` のパターン）。

---

## 6. `Curve` と `CurvedAnimation`

### `Curve` とは

- **入力 0〜1 に対して、出力 0〜1 を返す関数**（イージング）の抽象です。  
- 等速ではなく、**加速・減速・バウンス風**などに見せたいときに挟みます。

### `Curves` クラス

- **`Curves.easeIn`** や **`Curves.easeOutCubic`** など、**よく使うカーブの定数**がまとまっています。  
- ルート遷移の `SlideTransition` 用に **`Curves.easeOutCubic`** を使う例は `lib/example/hero_next.dart` にあります。

### `CurvedAnimation`

- **親となる `Animation<double>`**（多くは `AnimationController`）を受け取り、**`curve`（と任意で `reverseCurve`）** を適用した **`Animation<double>`** を作る。  
- 結果として、**同じ `duration` でも見た目の速さが変化**します（最初遅く最後速い、など）。

```dart
final curved = CurvedAnimation(
  parent: controller,
  curve: Curves.easeIn,
);
```

---

## 7. `Tween` とその周辺

### `Tween<T>` の役割

- **`begin` と `end` の間を補間**する。  
- 親は通常 **`Animation<double>`**（0〜1）で、**`Tween.animate(parent)`** で **`Animation<T>`** に変換できる。  
- フレームごとに **`tween.evaluate(animation)`** と書くか、`animate` した `Animation<T>` の **`value`** を読む。

### 代表的なサブクラス

| クラス | 補間する型の例 |
|--------|----------------|
| **`Tween<double>`** | 幅・高さ・不透明度の係数など |
| **`ColorTween`** | 色 |
| **`OffsetTween` / `RelativeRectTween`** | 位置 |
| **`RectTween`** | Hero の矩形飛行など（フレームワーク内部でも使用） |
| **`IntTween`** | 整数（カウンタ表示など） |

### `ConstantTween` / `CurveTween`

- **`ConstantTween`**：動かさず一定値を返したいとき。  
- **`CurveTween`**：`Curve` 自体をアニメーションとして扱いたいとき（ややマニアック）。

このリポジトリでは `Tween<double>(begin: 0, end: 300)` と `evaluate` を組み合わせてサイズを変えています（`logo_app.dart` / `my_animation.dart` の `AnimatedLogo` / `MyAnimatedImage`）。

---

## 8. `Listenable` と UI の更新

### `Listenable` とは

- **「変化を購読する」**ためのインターフェース。  
- `Animation` は `Listenable` なので、**値が変わるたびにリスナーが呼ばれる**。

### 典型パターン

1. **`addListener(() => setState(() {}))`** … 手書きで `build` を走らせる（冗長になりやすい）。  
2. **`AnimatedWidget`** … コンストラクタで `Listenable`（多くは `Animation`）を受け取り、通知のたびに **`build` が呼ばれる**（`AnimatedLogo` など）。  
3. **`AnimatedBuilder`** … `animation` と `builder` を渡し、**変化時だけ子ツリーを再構築**（部分的に効率的）。

---

## 9. `AnimatedWidget`

- **`Listenable` を `super.listenable` で渡す**ウィジェットの基底クラス。  
- サブクラスは **`build` の中で `listenable` をキャスト**して `Animation<T>` として使うことが多い。  
- **`setState` を書かずに**アニメーションに追従できるのが利点です。

---

## 10. `AnimatedBuilder`

- **`animation` + `builder(context, child)`** を取る。  
- **`child` を一度だけ作って渡す**と、再構築は `builder` の一部だけに抑えられる（子ツリーの再利用）。  
- `AnimationController` だけ動かして、重い子を毎フレーム作り直さない用途に向く。

---

## 11. 暗黙的アニメーション（対比用の一言）

**暗黙的（Implicit）** ウィジェット（例：`AnimatedOpacity`、`TweenAnimationBuilder`）は、内部でコントローラ相当の処理を隠し、**プロパティを変えれば自動で補間**します。  
本ドキュメントで詳しく扱った **`AnimationController` + `Tween` + `AnimatedWidget`** は **明示的**な側で、**制御と再利用の単位が違う**と理解すると整理しやすいです。

---

## 12. `Hero` と遷移アニメーション

### `Hero` ウィジェット

- **`tag`**（型は **`Object`**。文字列やデータモデルで一意に）で **ペア**を識別する。  
- **遷移元・遷移先の両方**に **同じ `tag`** の `Hero` があると、`Navigator` の push/pop 時に **共有要素遷移**が走る。  
- フレームワークが **`Rect` の補間**などを行い、一時的に **オーバーレイ上**で「飛んでいる」ように見せる。

### 子ウィジェットの構造

- 公式サンプルでは **`Material`（透明）+ `InkWell` + 画像**のようにすることが多いです（スプラッシュや飛行時の見た目のため）。  
- このリポジトリの `CoffeeHeroTile`（`lib/example/hero_next.dart`）も同様の形です。

### ページ遷移そのものの動き

- **`Hero` は矩形の飛行**を担当し、**画面全体がスライドするか**は **`PageRoute` の `transitionsBuilder`** などで別途決めます。  
- `hero_next.dart` では **`PageRouteBuilder` + `SlideTransition`** で横スライドしつつ、`Hero` で画像を大きく表示する、という **二重の見せ方**になっています。

---

## 13. ルート遷移で使う `Animation<double>`（参考）

`PageRouteBuilder` の **`transitionsBuilder`** には、**`animation`**（0→1）と **`secondaryAnimation`**（前のルート用）が渡ります。  
これらは **`FadeTransition` / `SlideTransition` / `RotationTransition`** などの **`Animation<double>` または `Animation<Offset>` 系**に **`animate(...)` で接続**します。  
`hero_next.dart` の `Tween<Offset>(begin: Offset(1,0), end: Offset.zero).animate(curved)` がその例です。

---

## 14. 用語の対応表（読むときの早見）

| オブジェクト | 一言で |
|--------------|--------|
| **`TickerProvider`** | `Ticker` を作れる。`vsync` に渡す。 |
| **`Ticker`** | VSync に合わせた刻み。 |
| **`AnimationController`** | 時間進行と再生 API。`Animation<double>` でもある。 |
| **`Animation<T>`** | 時系列の値 `T`。`Listenable`。 |
| **`AnimationStatus`** | 進行の段階（完了・逆方向など）。 |
| **`Curve` / `Curves`** | イージング曲線。 |
| **`CurvedAnimation`** | 親 `Animation<double>` に曲線を適用。 |
| **`Tween<T>`** | `begin`〜`end` の補間。 |
| **`AnimatedWidget` / `AnimatedBuilder`** | `Listenable` 変更に追従して UI 更新。 |
| **`Hero`** | ルート間で同 `tag` のウィジェットを接続表示。 |

---

## 15. 参考リンク

- [Introduction to animations](https://docs.flutter.dev/ui/animations)  
- [AnimationController](https://api.flutter.dev/flutter/animation/AnimationController-class.html)  
- [Animation\<T\>](https://api.flutter.dev/flutter/animation/Animation-class.html)  
- [Tween](https://api.flutter.dev/flutter/animation/Tween-class.html)  
- [CurvedAnimation](https://api.flutter.dev/flutter/animation/CurvedAnimation-class.html)  
- [Hero](https://api.flutter.dev/flutter/widgets/Hero-class.html)  
- [TickerProvider](https://api.flutter.dev/flutter/scheduler/TickerProvider-class.html)  
