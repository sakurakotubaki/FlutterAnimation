import 'package:flutter/material.dart';

class CurvesExample extends StatefulWidget {
  const CurvesExample({super.key});

  @override
  State<CurvesExample> createState() => _CurvesExampleState();
}

class _CurvesExampleState extends State<CurvesExample>
    with SingleTickerProviderStateMixin {
  static const List<_CurveItem> _curveItems = [
    _CurveItem('linear', Curves.linear),
    _CurveItem('decelerate', Curves.decelerate),
    _CurveItem('fastLinearToSlowEaseIn', Curves.fastLinearToSlowEaseIn),
    _CurveItem('linearToEaseOut', Curves.linearToEaseOut),
    _CurveItem('fastEaseInToSlowEaseOut', Curves.fastEaseInToSlowEaseOut),
    _CurveItem('ease', Curves.ease),
    _CurveItem('easeIn', Curves.easeIn),
    _CurveItem('easeInToLinear', Curves.easeInToLinear),
    _CurveItem('easeInSine', Curves.easeInSine),
    _CurveItem('easeInQuad', Curves.easeInQuad),
    _CurveItem('easeInCubic', Curves.easeInCubic),
    _CurveItem('easeInQuart', Curves.easeInQuart),
    _CurveItem('easeInQuint', Curves.easeInQuint),
    _CurveItem('easeInExpo', Curves.easeInExpo),
    _CurveItem('easeInCirc', Curves.easeInCirc),
    _CurveItem('easeInBack', Curves.easeInBack),
    _CurveItem('easeOut', Curves.easeOut),
    _CurveItem('easeOutSine', Curves.easeOutSine),
    _CurveItem('easeOutQuad', Curves.easeOutQuad),
    _CurveItem('easeOutCubic', Curves.easeOutCubic),
    _CurveItem('easeOutQuart', Curves.easeOutQuart),
    _CurveItem('easeOutQuint', Curves.easeOutQuint),
    _CurveItem('easeOutExpo', Curves.easeOutExpo),
    _CurveItem('easeOutCirc', Curves.easeOutCirc),
    _CurveItem('easeOutBack', Curves.easeOutBack),
    _CurveItem('easeInOut', Curves.easeInOut),
    _CurveItem('easeInOutSine', Curves.easeInOutSine),
    _CurveItem('easeInOutQuad', Curves.easeInOutQuad),
    _CurveItem('easeInOutCubic', Curves.easeInOutCubic),
    _CurveItem(
      'easeInOutCubicEmphasized',
      Curves.easeInOutCubicEmphasized,
    ),
    _CurveItem('easeInOutQuart', Curves.easeInOutQuart),
    _CurveItem('easeInOutQuint', Curves.easeInOutQuint),
    _CurveItem('easeInOutExpo', Curves.easeInOutExpo),
    _CurveItem('easeInOutCirc', Curves.easeInOutCirc),
    _CurveItem('easeInOutBack', Curves.easeInOutBack),
    _CurveItem('fastOutSlowIn', Curves.fastOutSlowIn),
    _CurveItem('slowMiddle', Curves.slowMiddle),
    _CurveItem('bounceIn', Curves.bounceIn),
    _CurveItem('bounceOut', Curves.bounceOut),
    _CurveItem('bounceInOut', Curves.bounceInOut),
    _CurveItem('elasticIn', Curves.elasticIn),
    _CurveItem('elasticOut', Curves.elasticOut),
    _CurveItem('elasticInOut', Curves.elasticInOut),
  ];

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _duration,
  )..repeat(reverse: true);

  Duration _duration = const Duration(milliseconds: 1600);

  bool get _isAnimating => _controller.isAnimating;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.repeat(reverse: true);
    }
    setState(() {});
  }

  void _updateDuration(double seconds) {
    final wasAnimating = _controller.isAnimating;
    setState(() {
      _duration = Duration(milliseconds: (seconds * 1000).round());
      _controller.duration = _duration;
    });
    if (wasAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curves Preview'),
        actions: [
          IconButton(
            onPressed: _toggleAnimation,
            icon: Icon(_isAnimating ? Icons.pause : Icons.play_arrow),
            tooltip: _isAnimating ? '停止' : '再生',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '全 Curve 比較デモ',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '同じ距離・同じ時間で動かし、Curve ごとの差だけを見比べられるようにしています。',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('遅い'),
                        Expanded(
                          child: Slider(
                            min: 0.6,
                            max: 4.0,
                            divisions: 17,
                            value: _duration.inMilliseconds / 1000,
                            label:
                                '${(_duration.inMilliseconds / 1000).toStringAsFixed(1)} 秒',
                            onChanged: _updateDuration,
                          ),
                        ),
                        const Text('速い'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: _curveItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CurvePreviewTile(
                    item: _curveItems[index],
                    animation: _controller,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CurvePreviewTile extends StatelessWidget {
  const _CurvePreviewTile({
    required this.item,
    required this.animation,
  });

  final _CurveItem item;
  final Animation<double> animation;

  bool get _usesBall =>
      item.name.contains('bounce') || item.name.contains('elastic');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                const moverSize = 30.0;
                final maxTravel = constraints.maxWidth - moverSize;

                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final curvedValue = item.curve.transform(animation.value);
                    final offsetX = curvedValue * maxTravel;

                    return SizedBox(
                      height: 52,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary.withValues(
                                        alpha: 0.18,
                                      ),
                                      theme.colorScheme.secondary.withValues(
                                        alpha: 0.18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: offsetX,
                            top: 11,
                            child: child!,
                          ),
                        ],
                      ),
                    );
                  },
                  child: _CurveMover(
                    useBall: _usesBall,
                    colorScheme: theme.colorScheme,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CurveMover extends StatelessWidget {
  const _CurveMover({
    required this.useBall,
    required this.colorScheme,
  });

  final bool useBall;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: useBall ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: useBall ? null : BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.22),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
    );
  }
}

class _CurveItem {
  const _CurveItem(this.name, this.curve);

  final String name;
  final Curve curve;
}