# Flutterでアニメーションをやってみる

## 読んでほしい人
- Flutterのアニメーションに興味がある.
- アプリに動きをつけたい

## 記事の内容
https://docs.flutter.dev/ui/widgets/animation

アニメーションのCookBookが公式にあるので、今回はこちらを参考にチュートリアルをやってみようと思います。

### ⁉️bool型の変数だけでアニメーション
bool型の変数を使って、オブジェクトをタップすと、`icon`の位置が変わるアニメーションを使う例です。

https://api.flutter.dev/flutter/widgets/AnimatedAlign-class.html

:::details boolだけでアニメーションを表現
```dart
import 'package:flutter/material.dart';

class AnimatedAlignExample extends StatefulWidget {
  const AnimatedAlignExample({super.key});

  @override
  State<AnimatedAlignExample> createState() => _AnimatedAlignExampleState();
}

class _AnimatedAlignExampleState extends State<AnimatedAlignExample> {
  // bool型のselectedを定義し、初期値をfalseに設定
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedAlign Example'),
      ),
      // 赤いコンテナをタップすると、true/falseが切り替わり、iconが右上/左下に移動する.
      body: GestureDetector(
        onTap: () {
          setState(() {
            selected = !selected;
          });
        },
        child: Center(
          child: Container(
            width: 250.0,
            height: 250.0,
            color: Colors.red,
            child: AnimatedAlign(
              // 三項演算子でalignmentを切り替える
              alignment: selected ? Alignment.topRight : Alignment.bottomLeft,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              child: const FlutterLogo(size: 50.0),
            ),
          ),
        ),
      ),
    );
  }
}
```
:::

### 🕐AnimatedBuilder classを使う
https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html

アニメーションを構築するための汎用ウィジェット。

AnimatedBuilder は、より大きなビルド関数の一部としてアニメーションを含めたい、より複雑なウィジェットに役立ちます。 AnimatedBuilder を使用するには、ウィジェットを構築し、それにビルダー関数を渡します。

追加の状態のない単純なケースの場合は、AnimatedWidget の使用を検討してください。

名前にもかかわらず、AnimatedBuilder はアニメーションに限定されず、Listenable の任意のサブタイプ (ChangeNotifier や ValueNotifier など) を使用してリビルドをトリガーできます。 これらの実装は同一ですが、アニメーションがリッスンされていない場合は、読みやすさを向上させるために ListenableBuilder の使用を検討してください。

パフォーマンスの最適化
ビルダー関数に、コンストラクターに渡されたアニメーションに依存しないサブツリーが含まれている場合は、アニメーション ティックごとにサブツリーを再構築するのではなく、そのサブツリーを 1 回構築する方が効率的です。

事前に構築されたサブツリーが子パラメータとして渡された場合、AnimatedBuilder はそれをビルダー関数に返し、それをビルドに組み込むことができます。

この事前構築された子の使用は完全にオプションですが、場合によってはパフォーマンスが大幅に向上する可能性があるため、使用することをお勧めします。

### 動画の説明を解説すると
Flutterのアニメーションフレームワークは、ウイジェットを簡単にアニメートするオプションをたくさん提供します。
AnimatedBuilderはおすすめだそうで、使い方は簡単。まずアニメーションをTweenで与えて、0~360繰り返す。
次に、builderを与えてアニメートするウィジェットに返します。回転トランスフォームを使用してスピン効果を作成してます。
なので、公式のはくるくる回ってる。

:::details くるくる回るアニメーション
```dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBuilderExample extends StatefulWidget {
  const AnimatedBuilderExample({super.key});

  @override
  State<AnimatedBuilderExample> createState() => _AnimatedBuilderExampleState();
}

///AnimationController は `vsync:this` で作成できます。
/// TickerProviderStateMixin.
class _AnimatedBuilderExampleState extends State<AnimatedBuilderExample>
    with TickerProviderStateMixin {
  // lateをAnimationControllerにつけると、初期化を遅らせることができる。..repeat()で繰り返しアニメーションを行う。
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat();

  // AnimationControllerを破棄する必要があるので、dispose()をオーバーライドする。
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilderは、アニメーションの値を受け取り、ウィジェットを構築する。
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedBuilder Example'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller, // AnimationControllerを渡す。
          child: Container(
            width: 200.0,
            height: 200.0,
            color: Colors.green,
            child: const Center(
              child: Text('くるくる回っちゃうもんね〜'),
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            // Transform.rotateで回転させる。
            return Transform.rotate(
              angle: _controller.value * 2.0 * math.pi,
              child: child,
            );
          },
        ),
      ),
    );
  }
}
```
:::

### AnimatedContainer class
https://api.flutter.dev/flutter/widgets/AnimatedContainer-class.html

一定期間にわたって値が徐々に変化するコンテナのアニメーション バージョン。

AnimatedContainer は、プロパティの古い値と新しい値が変更されると、指定されたカーブと期間を使用してそれらの間で自動的にアニメーション化します。 null のプロパティはアニメーション化されません。 その子と子孫はアニメーション化されません。

このクラスは、内部のAnimationControllerを使用して、コンテナへのさまざまなパラメータ間の単純な暗黙的な遷移を生成するのに役立ちます。 より複雑なアニメーションの場合は、DecoratedBoxTransition などの AnimatedWidget のサブクラスを使用するか、独自の AnimationController を使用することになるでしょう。

`setState`の呼び出しに対応させる形で、他の値を使ってクラスを再びビルドすると、AnimatedContainerがその二つの値の線形補間を行います。

色に限らず外枠、外枠半径、背景画像、影、グラデーション、形、内側の余白、幅、高さ、配置、変換などいろいろあります。

アニメーションの長さは、durationパラメータが操作し`Curves`を明示しエフェクトをカスタマイズすることもできます。


動画によると、暗示的なアニメーション用のウイジェットもあるとのこと。
アニメーションが自動で変化する。色などの属性を加えて１回作成するだけです。

:::details コンテナの形と色が変わるアニメーション
```dart
import 'package:flutter/material.dart';

class AnimatedContainerExample extends StatefulWidget {
  const AnimatedContainerExample({super.key});

  @override
  State<AnimatedContainerExample> createState() =>
      _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  // bool型のselectedを定義し、初期値をfalseに設定
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedContainer Example'),
      ),
      // 赤いコンテナをタップすると、true/falseが切り替わり、iconが右上/左下に移動する.
      body: GestureDetector(
        onTap: () {
          setState(() {
            selected = !selected;
          });
        },
        child: Center(
          // AnimatedContainerは、アニメーションの値を受け取り、ウィジェットを構築する。
          child: AnimatedContainer(
            width: selected ? 200.0 : 100.0,
            height: selected ? 100.0 : 200.0,
            color: selected ? Colors.red : Colors.blue,
            alignment:
                selected ? Alignment.center : AlignmentDirectional.topCenter,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,// fastOutSlowInは、アニメーションの開始と終了が遅く、中間が速い。
            child: const FlutterLogo(size: 75),
          ),
        ),
      ),
    );
  }
}
```
:::

### AnimatedCrossFade class
https://api.flutter.dev/flutter/widgets/AnimatedCrossFade-class.html

指定された 2 つの子の間でクロスフェードし、それらのサイズ間でアニメーション化するウィジェット。
アニメーションは、crossFadeState パラメータを通じて制御されます。 firstCurve と SecondCurve は、2 つの子の不透明度カーブを表します。 firstCurve は反転されています。つまり、Curves.linear のような成長曲線を提供するときにフェードアウトします。 sizeCurve は、フェードアウトする子のサイズとフェードインする子のサイズの間をアニメーション化するために使用されるカーブです。

このウィジェットは、同じ幅のウィジェットのペアをフェードするために使用することを目的としています。 2 人の子の高さが異なる場合、アニメーションはアニメーション中に上端を揃えてオーバーフローする子を切り取ります。つまり、下端がクリップされます。

既存の AnimatedCrossFade が CrossFadeState プロパティの異なる値で再構築されると、アニメーションが自動的にトリガーされます。

### 動画による
クロスフェードは、映画用語で次第に一報を消す代わりにもう一報を表示させることを指します。
あるウイジェットを別のウイジェットと突然でなく次第に入れ替えるなんらかの方法。

:::details ２パターン作った
ボタンを押すと実行されるアニメーション:
```dart
import 'package:flutter/material.dart';

class AnimatedCrossFadeExample extends StatefulWidget {
  const AnimatedCrossFadeExample({super.key});

  @override
  _AnimatedCrossFadeExampleState createState() => _AnimatedCrossFadeExampleState();
}

class _AnimatedCrossFadeExampleState extends State<AnimatedCrossFadeExample> {
  // 初期値がtrueなので、最初はfirstChildが表示される
  bool _first = true;

  @override
  void initState() {
    // initStateでsetStateを呼ぶとエラーになるので、initStateの中では呼ばない
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedCrossFade Example'),
      ),
      body: Center(
        child: AnimatedCrossFade(
          duration: const Duration(seconds: 3),// 3秒かけてアニメーションする
          // firstChildは最初に表示されるWidget
          firstChild: const FlutterLogo(style: FlutterLogoStyle.horizontal, size: 100.0),
          // secondChildはfirstChildが消えた後に表示されるWidget
          secondChild: const FlutterLogo(style: FlutterLogoStyle.stacked, size: 100.0),
          crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ボタンを押さないとfirstChildとsecondChildが切り替わらないので、押して切り替える
          setState(() {
            _first = !_first;
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

画面が呼ばれると実行されるアニメーション:
```dart
import 'package:flutter/material.dart';

class AnimatedCrossFadeExample extends StatefulWidget {
  const AnimatedCrossFadeExample({Key? key}) : super(key: key);

  @override
  _AnimatedCrossFadeExampleState createState() =>
      _AnimatedCrossFadeExampleState();
}

class _AnimatedCrossFadeExampleState extends State<AnimatedCrossFadeExample> {
  // 初期値がtrueなので、最初はfirstChildが表示される
  bool _first = true;

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  Future<void> _loadAnimation() async {
    // 画面が呼ばれたときにアニメーションを開始
    Future.delayed(Duration.zero, () {
      setState(() {
        _first = !_first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedCrossFade Example'),
      ),
      body: Center(
        child: AnimatedCrossFade(
          duration: const Duration(seconds: 3), // 3秒かけてアニメーションする
          // firstChildは最初に表示されるWidget
          firstChild: const FlutterLogo(
              style: FlutterLogoStyle.horizontal, size: 100.0),
          // secondChildはfirstChildが消えた後に表示されるWidget
          secondChild:
              const FlutterLogo(style: FlutterLogoStyle.stacked, size: 100.0),
          crossFadeState:
              _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
      ),
    );
  }
}
```
:::

## 補足情報
サンプルコードには、`Scaffold`書いてなかったり書いてある場所が変なので修正して私は使ってます。なかったら画面真っ黒になるよ!

## 最後に
今回はアニメーションの公式ドキュメントを見てみました。種類が多すぎて紹介しきれないなと思ってこんなふうにやったらできましたよ〜って記事を書いてみました!
自分で作ったアプリにアニメーションで動きをつけてリッチなアプリにしてみたい人は使ってみてね💚🩵💙
