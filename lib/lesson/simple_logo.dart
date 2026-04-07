import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HooksAnimationo extends HookWidget {
  const HooksAnimationo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: const Duration(seconds: 2));
    final animation = useAnimation(Tween<double>(begin: 0, end: 300).animate(controller));

    useEffect(() {
      controller.repeat();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hooks Animation'),
        actions: [
          IconButton(onPressed: () {
            controller.stop();
          }, icon: const Icon(Icons.stop)),
          IconButton(onPressed: () {
            controller.reset();
          }, icon: const Icon(Icons.reset_tv)),
          IconButton(onPressed: () {
            controller.forward();
          }, icon: const Icon(Icons.play_arrow)),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        if (controller.isAnimating) {
          controller.stop();
        } else {
          controller.repeat();
        }
      }, child: const Icon(Icons.play_arrow)),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: animation,
          height: animation,
          child: const FlutterLogo(),
        ),
      ));
  }
}

// class SimpleLogo extends StatefulWidget {
//   const SimpleLogo({super.key});

//   @override
//   State<SimpleLogo> createState() => _SimpleLogoState();
// }

// class _SimpleLogoState extends State<SimpleLogo> with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//   late Animation<double> animation;

//   @override
//   void initState() {
//     super.initState();
//     controller =
//         AnimationController(duration: const Duration(seconds: 2), vsync: this);
//     animation = Tween<double>(begin: 0, end: 300).animate(controller)
//       ..addListener(() {
//         setState(() {
//           // The state that has changed here is the animation object's value.
//         });
//       });
//     // controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           // stop
//           IconButton(onPressed: () {
//             controller.stop();
//           }, icon: const Icon(Icons.stop)),
//           // play
//           IconButton(onPressed: () {
//             controller.reset();
//             controller.forward();
//           }, icon: const Icon(Icons.reset_tv)),
//         ],
//         title: const Text('Simple Logo'),
//       ),
//       floatingActionButton: FloatingActionButton(onPressed: () {
//         if (controller.isAnimating) {
//             controller.stop();
//           } else {
//             controller.repeat();
//           }
//         },
//         child: const Icon(Icons.play_arrow),
//       ),
//       body: C
//     );
//   }
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }