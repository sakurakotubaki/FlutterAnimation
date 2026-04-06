import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class FogAnimationPage extends StatelessWidget {
  const FogAnimationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3D4F),
      body: Stack(
        children: [
          const Center(
            child: Text(
              'MIST',
              style: TextStyle(
                color: Color(0x55FFFFFF),
                fontSize: 72,
                fontWeight: FontWeight.w900,
                letterSpacing: 24,
              ),
            ),
          ),
          Positioned.fill(
            child: FutureBuilder<ui.FragmentProgram>(
              future: ui.FragmentProgram.fromAsset('shaders/mist.frag'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                return _MistShaderWidget(program: snapshot.data!);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// シェーダーアニメーションウィジェット
// ---------------------------------------------------------------------------

class _MistShaderWidget extends StatefulWidget {
  const _MistShaderWidget({required this.program});
  final ui.FragmentProgram program;

  @override
  State<_MistShaderWidget> createState() => _MistShaderWidgetState();
}

class _MistShaderWidgetState extends State<_MistShaderWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final ui.FragmentShader _shader;

  @override
  void initState() {
    super.initState();
    _shader = widget.program.fragmentShader();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _shader.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _MistShaderPainter(
            shader: _shader,
            elapsed: _controller.lastElapsedDuration?.inMilliseconds ?? 0,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// CustomPainter — uniform を設定してシェーダーで全画面塗り
// ---------------------------------------------------------------------------

class _MistShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final int elapsed;

  _MistShaderPainter({required this.shader, required this.elapsed});

  @override
  void paint(Canvas canvas, Size size) {
    // uniform float uTime  (index 0)
    shader.setFloat(0, elapsed / 1000.0);
    // uniform vec2 uSize   (index 1, 2)
    shader.setFloat(1, size.width);
    shader.setFloat(2, size.height);

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant _MistShaderPainter oldDelegate) => true;
}
