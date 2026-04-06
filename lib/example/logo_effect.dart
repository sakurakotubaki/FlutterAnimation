import 'package:flutter/material.dart';

/// Material アイコン周囲が「光る」ように見せるデモ。
///
/// 知識の要点（学習メモ）:
/// - [AnimationController]: 時間を 0〜1 で進め、毎フレーム [Listenable] として通知する。
/// - [SingleTickerProviderStateMixin]: `vsync: this` で [Ticker] を提供する（1 本のコントローラ用）。
/// - [CurvedAnimation] / [Curves]: 進み方を滑らかにする（イージング）。
/// - [AnimatedBuilder]: アニメーション値が変わったときだけ子を再構築する。
/// - [BoxDecoration.boxShadow]: ぼかし・広がり・色の透明度を変えると「発光」に見える。
///   より凝る場合は [ShaderMask]、[CustomPainter]、画像フィルタなども選択肢。
class LogoEffect extends StatefulWidget {
  const LogoEffect({super.key});

  @override
  State<LogoEffect> createState() => _LogoEffectState();
}

class _LogoEffectState extends State<LogoEffect> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1800),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _pulse = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Glow'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) {
            final t = _pulse.value;
            final blur = 10.0 + t * 28.0;
            final spread = t * 3.0;
            final outerAlpha = 0.35 + t * 0.4;
            final innerAlpha = 0.2 + t * 0.3;

            return Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: outerAlpha),
                    blurRadius: blur,
                    spreadRadius: spread,
                  ),
                  BoxShadow(
                    color: scheme.secondary.withValues(alpha: innerAlpha),
                    blurRadius: blur * 0.65,
                    spreadRadius: spread * 0.4,
                  ),
                  BoxShadow(
                    color: scheme.tertiary.withValues(alpha: innerAlpha * 0.7),
                    blurRadius: blur * 0.35,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Icon(
            Icons.flutter_dash,
            size: 88,
            color: scheme.primary,
            shadows: [
              Shadow(
                color: scheme.primary.withValues(alpha: 0.35),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
