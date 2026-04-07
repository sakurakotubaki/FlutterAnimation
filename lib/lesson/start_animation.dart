import 'package:flutter/material.dart';

class StartAnimation extends StatefulWidget {
  const StartAnimation({super.key});

  @override
  State<StartAnimation> createState() => _StartAnimationState();
}

class _StartAnimationState extends State<StartAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // void _onStarTap() {
  //   if (_controller.isAnimating) return;
  //   _controller.forward().then((_) {
  //     if (mounted) _controller.reverse();
  //   });
  // }
  Future<void> _onStarTap() async {
    if (_controller.isAnimating) return;
    await _controller.forward();
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Animation'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _onStarTap,
          behavior: HitTestBehavior.opaque,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: const Icon(
              Icons.star,
              size: 72,
              color: Colors.amber,
            ),
          ),
        ),
      ),
    );
  }
}
