import 'package:flutter/material.dart';

/// AnimatedWidget を継承して、アニメーションの値を受け取る。
class MyAnimatedImage extends AnimatedWidget {
  const MyAnimatedImage({super.key, required Animation<double> animation})
      : super(listenable: animation);

  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 300);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: _sizeTween.evaluate(animation),
          height: _sizeTween.evaluate(animation),
          child: Image.asset('assets/images/coffee.png'),
        ),
      ),
    );
  }
}

/// StatefulWidget を継承して、アニメーションの値を受け取る。
/// SingleTickerProviderStateMixin を継承して、アニメーションの値を受け取る。
class MyAnimation extends StatefulWidget {
  const MyAnimation({super.key});

  @override
  State<MyAnimation> createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation> with SingleTickerProviderStateMixin {
  /// AnimationController を作成する。
  late AnimationController controller;
  /// Animation<double> を作成する。
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    /// AnimationController を作成する。
    /// vsync: this で、アニメーションの速度を制御する。
    /// thisの役割は、TickerProviderStateMixinを継承していることを示す。
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  /// Animationを停止するメソッド
  void _stopAnimation() {
    controller.stop();
  }

  /// Animationを開始するメソッド
  void _startAnimation() {
    controller.forward();
  }

  /// Animationをリバースするメソッド
  void _reverseAnimation() {
    controller.reverse();
  }

  /// AnimationController を破棄する。
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Animation'),
        actions: [
          IconButton(onPressed: _stopAnimation, icon: const Icon(Icons.stop)),
          IconButton(onPressed: _startAnimation, icon: const Icon(Icons.play_arrow)),
          IconButton(onPressed: _reverseAnimation, icon: const Icon(Icons.replay)),
        ],
      ),
      body: MyAnimatedImage(animation: animation),
    );
  }
}