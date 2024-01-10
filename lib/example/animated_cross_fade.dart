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

// class AnimatedCrossFadeExample extends StatefulWidget {
//   const AnimatedCrossFadeExample({super.key});

//   @override
//   _AnimatedCrossFadeExampleState createState() => _AnimatedCrossFadeExampleState();
// }

// class _AnimatedCrossFadeExampleState extends State<AnimatedCrossFadeExample> {
//   // 初期値がtrueなので、最初はfirstChildが表示される
//   bool _first = true;

//   @override
//   void initState() {
//     // initStateでsetStateを呼ぶとエラーになるので、initStateの中では呼ばない
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AnimatedCrossFade Example'),
//       ),
//       body: Center(
//         child: AnimatedCrossFade(
//           duration: const Duration(seconds: 3),// 3秒かけてアニメーションする
//           // firstChildは最初に表示されるWidget
//           firstChild: const FlutterLogo(style: FlutterLogoStyle.horizontal, size: 100.0),
//           // secondChildはfirstChildが消えた後に表示されるWidget
//           secondChild: const FlutterLogo(style: FlutterLogoStyle.stacked, size: 100.0),
//           crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // ボタンを押さないとfirstChildとsecondChildが切り替わらないので、押して切り替える
//           setState(() {
//             _first = !_first;
//           });
//         },
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
// }
