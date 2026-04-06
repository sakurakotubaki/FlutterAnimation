import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroine/heroine.dart';

/// [heroine](https://pub.dev/packages/heroine) 公式サンプル（`example/lib/image_grid.dart`）に近い UI:
/// **カード内の画像** → **[FlipShuttleBuilder] でクルッと回転**しつつ遷移 → 詳細でカード裏面風の UI。
///
/// アプリには [HeroineController] を [MaterialApp.navigatorObservers] に登録すること。
///
/// 参考: [heroine package](https://pub.dev/packages/heroine)
const Object _coffeeHeroineTag = 'coffee_card_demo';

/// エントリ: 中央にコーヒーカード 1 枚。
class HeroineExample extends StatelessWidget {
  const HeroineExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heroine · カード反転'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Heroine(
            tag: _coffeeHeroineTag,
            motion: const CupertinoMotion.bouncy(),
            flightShuttleBuilder: const FlipShuttleBuilder(
              axis: Axis.vertical,
              halfFlips: 1,
            ),
            child: SizedBox(
              width: 240,
              height: 240,
              child: CoffeeCardCover(
                isFlipped: false,
                onPressed: () {
                  Navigator.of(context).push<void>(
                    CoffeeFlipRoute<void>(
                      settings: const RouteSettings(name: 'coffee-detail'),
                      pageTitle: 'Coffee',
                      fullscreenDialog: true,
                      builder: (context) => const _CoffeeFlipDetailPage(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 公式 [Cover] に相当: 表面は画像、裏面はグラデーション + ラベル。
class CoffeeCardCover extends StatelessWidget {
  const CoffeeCardCover({
    super.key,
    required this.isFlipped,
    this.onPressed,
  });

  final bool isFlipped;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(28);
    return Material(
      elevation: isFlipped ? 20 : 10,
      shadowColor: Colors.brown.withValues(alpha: 0.35),
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: isFlipped
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blueGrey.shade100,
                      Colors.blueGrey.shade300,
                    ],
                  )
                : null,
            image: isFlipped
                ? null
                : const DecorationImage(
                    image: AssetImage('assets/images/coffee.png'),
                    fit: BoxFit.cover,
                  ),
          ),
          child: isFlipped
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Coffee',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.blueGrey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

/// 公式 `MyCustomRoute` 相当: [CupertinoRouteTransitionMixin] + [HeroinePageRouteMixin]。
/// モーダル風にフェードしつつ、[Heroine] の dismiss ジェスチャと連動できる。
class CoffeeFlipRoute<T> extends PageRoute<T>
    with CupertinoRouteTransitionMixin, HeroinePageRouteMixin {
  CoffeeFlipRoute({
    required this.settings,
    required String pageTitle,
    required this.builder,
    super.fullscreenDialog = false,
  }) : _pageTitle = pageTitle,
       super(settings: settings);

  final String _pageTitle;

  @override
  final RouteSettings settings;

  final Widget Function(BuildContext context) builder;

  @override
  String? get title => _pageTitle;

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => fullscreenDialog
      ? const Duration(milliseconds: 300)
      : super.transitionDuration;

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (fullscreenDialog) {
      return FadeTransition(opacity: animation, child: child);
    }
    return CupertinoRouteTransitionMixin.buildPageTransitions(
      this,
      context,
      animation,
      const AlwaysStoppedAnimation<double>(0),
      child,
    );
  }
}

class _CoffeeFlipDetailPage extends StatelessWidget {
  const _CoffeeFlipDetailPage();

  static const _body =
      '公式サンプルではグリッドの各カードから遷移し、FlipShuttleBuilder で '
      '表面の写真から裏面のプレースホルダへ「めくれる」ように見せています。';

  @override
  Widget build(BuildContext context) {
    return ReactToHeroineDismiss(
      builder: (context, progress, offset, child) {
        final opacity = 1 - progress;
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: opacity * 16,
              sigmaY: opacity * 16,
            ),
            child: Scaffold(
              backgroundColor: Theme.of(context)
                  .scaffoldBackgroundColor
                  .withValues(alpha: opacity),
              body: child,
            ),
          ),
        );
      },
      child: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Coffee'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.48,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: DragDismissable(
                      child: Heroine(
                        tag: _coffeeHeroineTag,
                        motion: const CupertinoMotion.bouncy(),
                        flightShuttleBuilder: const FlipShuttleBuilder(
                          axis: Axis.vertical,
                          halfFlips: 1,
                        ),
                        child: CoffeeCardCover(
                          isFlipped: true,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
            sliver: SliverToBoxAdapter(
              child: Text(
                _body,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
