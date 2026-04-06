import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 雨が降る画面のサンプル。
///
/// ## 作るときの考え方（過程）
///
/// 1. **雰囲気（背景）**  
///    雨は「細い線」で表現する前に、**薄暗い空・曇り**を先に決める。  
///    グラデーションややや濃い下方向で、地面付近がさらに暗いと「雨の日」に寄りやすい。
///
/// 2. **雨粒の表現**  
///    - 実際の雨に近いのは **短い斜線（ストリーク）**（細長い矩形でも可）。  
///    - 端末負荷を抑えるなら `CustomPainter` で **一括描画**（数千個は避け、数十〜数百程度）。  
///    - 奥行きのために **太さ・長さ・透明度・速度** をばらつかせる。
///
/// 3. **アニメーションの選び方**  
///    - 落下は **等速に近い**方が自然 → `AnimationController` を **`repeat()`** し、  
///      進行度 `0→1` を **Y 座標のオフセット**に直結（または線形補間）。  
///    - イージング（`Curves.easeIn` 等）は基本いらない。雨は一定加速度で見えることが多い。  
///    - 粒ごとに **位相 `phase` と速度 `speed`** を変えると、ループが単調に見えにくい。
///
/// 4. **向き**  
///    画面座標では **Y が増えるほど下**。雨線は **上端 `(x, y)` → 下端 `(x, y+長さ)`** とすると
///    真上から真下へ落ちる見え方になる。斜めにしたいときだけ終点 X を少しずらす。
///
/// 5. **パフォーマンス**  
///    - 毎フレーム `setState` で大量のウィジェットを動かすより、`CustomPainter` + `AnimatedBuilder` が軽い。  
///    - 必要なら `RepaintBoundary` で雨レイヤーだけ再描画。
///
/// このファイルでは上記を最小構成で実装している。
class RainAnimation extends StatefulWidget {
  const RainAnimation({super.key});

  @override
  State<RainAnimation> createState() => _RainAnimationState();
}

class _RainAnimationState extends State<RainAnimation>
    with SingleTickerProviderStateMixin {
  static const int _dropCount = 120;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  late final List<_RainDrop> _drops;

  @override
  void initState() {
    super.initState();
    final r = math.Random(42);
    _drops = List<_RainDrop>.generate(_dropCount, (_) {
      return _RainDrop(
        x: r.nextDouble(),
        phase: r.nextDouble(),
        speed: 0.6 + r.nextDouble() * 1.0,
        length: 12 + r.nextDouble() * 22,
        thickness: 0.6 + r.nextDouble() * 1.2,
        opacity: 0.12 + r.nextDouble() * 0.22,
        // 縦の雨にする（斜めにしたい場合は ± 数 px など）
        windDx: 0,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _CloudyBackground(),
          // 手前の霧っぽい層（薄い半透明）
          const _FogOverlay(),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _RainPainter(
                    progress: _controller.value,
                    drops: _drops,
                  ),
                  child: const SizedBox.expand(),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  '雨の降るアニメーション',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white70,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 曇り空：上がやや明るく、下が暗いグラデーション。
class _CloudyBackground extends StatelessWidget {
  const _CloudyBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4a5568),
            Color(0xFF2d3748),
            Color(0xFF1a202c),
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}

/// 画面全体に薄い縦グラデーションを重ねて「曇り・湿気」を補強。
class _FogOverlay extends StatelessWidget {
  const _FogOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueGrey.shade800.withValues(alpha: 0.12),
              Colors.black.withValues(alpha: 0.18),
            ],
          ),
        ),
      ),
    );
  }
}

class _RainDrop {
  const _RainDrop({
    required this.x,
    required this.phase,
    required this.speed,
    required this.length,
    required this.thickness,
    required this.opacity,
    this.windDx = 0,
  });

  /// 0〜1 の正規化 X
  final double x;

  /// ループの位相ずれ
  final double phase;

  /// 落下速度の倍率
  final double speed;

  /// ストリークの長さ（ピクセル）
  final double length;

  final double thickness;
  final double opacity;

  /// 1 本の雨線の終点を横にずらす量（縦主体のときは 0〜数 px）
  final double windDx;
}

class _RainPainter extends CustomPainter {
  _RainPainter({
    required this.progress,
    required this.drops,
  });

  final double progress;
  final List<_RainDrop> drops;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const travel = 1.15;

    for (final d in drops) {
      final t = ((progress * d.speed + d.phase) % 1.0) * travel;
      // 上端の Y：t が増えると全体が下へ移動（上から下へ落ちる）
      final yTop = t * (h + 80) - 40;
      final x = d.x * w;

      final p = Paint()
        ..color = Colors.white.withValues(alpha: d.opacity)
        ..strokeWidth = d.thickness
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      // 上端 → 下端（+Y 方向）。windDx は斜めを控えめに足すだけ。
      final yBottom = yTop + d.length;
      canvas.drawLine(
        Offset(x, yTop),
        Offset(x + d.windDx, yBottom),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RainPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.drops != drops;
  }
}
