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
