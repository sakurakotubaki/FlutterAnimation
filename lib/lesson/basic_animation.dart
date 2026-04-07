import 'package:flutter/material.dart';

class BasicAnimation extends StatefulWidget {
  const BasicAnimation({super.key});

  @override
  State<BasicAnimation> createState() => _BasicAnimationState();
}

class _BasicAnimationState extends State<BasicAnimation> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Animation'),
        actions: [
          IconButton(onPressed: () {
            controller.forward();
          }, icon: const Icon(Icons.play_arrow)),
          IconButton(onPressed: () {
            controller.reverse();
          }, icon: const Icon(Icons.pause)),
          IconButton(onPressed: () {
            controller.stop();
          }, icon: const Icon(Icons.stop)),
          IconButton(onPressed: () {
            controller.reset();
          }, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () {
            controller.repeat();
          }, icon: const Icon(Icons.repeat)),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
         // 跳ね中でなければ実行
        if (!controller.isAnimating) {
          controller.reset();
          controller.forward();
        }
      }, child: const Icon(Icons.arrow_upward)),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                // "跳ねる"（バウンステイスト）アニメーション: 下から上にジャンプし落ちる
                final double t = animation.value; // t: 0〜100
                // 縦方向の移動: 0 → -jumpHeight → 0 (パラボラ)
                // 軽いバウンスを加えるイージング
                const double jumpHeight = 120.0;
                // 0→1→0となるtの進行度（0〜100→0〜1→0）
                final double progress = t / 100.0;
                // 跳ね高さのイージング（「山」形）
                final double dy = -jumpHeight * (4 * progress * (1 - progress));
                // 跳ねるアニメーションを適用
                return Transform.translate(
                  offset: Offset(0, dy),
                  child: Container(
                    width: 120,
                    height: 120,
                    alignment: Alignment.bottomCenter,
                    child: const Icon(
                      Icons.flutter_dash,
                      size: 100,
                      color: Colors.blue,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ));
  }
}