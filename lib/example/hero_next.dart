import 'package:flutter/material.dart';

/// [Hero] のタグ（ソースとデスティネーションで一致させる）。
const String coffeeHeroHorizontalTag = 'coffee_horizontal';

/// コーヒー画像を [Hero] で包む（公式 PhotoHero パターン）。
class CoffeeHeroTile extends StatelessWidget {
  const CoffeeHeroTile({
    super.key,
    required this.width,
    this.onTap,
  });

  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: coffeeHeroHorizontalTag,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(
              'assets/images/coffee.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

/// 右からスライドインするルート（横方向の画面遷移）。
Route<void> coffeeHorizontalDetailRoute(Widget page) {
  return PageRouteBuilder<void>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 360),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  );
}

/// 一覧：左にコーヒーを置き、タップで横遷移＋Hero で右へ拡大。
class CoffeeHeroHorizontalDemo extends StatelessWidget {
  const CoffeeHeroHorizontalDemo({super.key});

  static const double _thumbWidth = 72;
  static const double _detailWidth = 340;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee · 横遷移 + Hero'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CoffeeHeroTile(
                    width: _thumbWidth,
                    onTap: () {
                      Navigator.of(context).push<void>(
                        coffeeHorizontalDetailRoute(
                          const _CoffeeHorizontalDetailPage(
                            heroWidth: _detailWidth,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'コーヒー',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '左のコーヒーをタップすると、\n画面が横から入り、画像が横方向に大きく表示されます。',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoffeeHorizontalDetailPage extends StatelessWidget {
  const _CoffeeHorizontalDetailPage({required this.heroWidth});

  final double heroWidth;

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.sizeOf(context).width - 32;
    final w = heroWidth.clamp(120.0, maxW);

    return Scaffold(
      appBar: AppBar(
        title: const Text('コーヒー詳細'),
      ),
      body: ColoredBox(
        color: Colors.blueGrey.shade50,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerRight,
              child: CoffeeHeroTile(
                width: w,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
