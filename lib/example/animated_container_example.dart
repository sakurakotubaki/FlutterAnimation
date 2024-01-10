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
