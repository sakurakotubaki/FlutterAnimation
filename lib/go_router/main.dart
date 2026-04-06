import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:animation_tutorial/example/hero_animation_widget.dart';

/// go_router + Hero のサンプル。
///
/// 実行例:
/// ```bash
/// flutter run -t lib/go_router/main.dart
/// ```
///
/// ポイント:
/// - 一覧 → 詳細は **`context.push`**（スタックに積む）。`go` は置き換えになり、Hero が期待通り動かないことが多い。
/// - 詳細から戻るは **`context.pop()`**。
/// - [Hero] の `tag` は遷移元・先で一致させる（ここでは [Drink.id]）。
void main() {
  runApp(const GoRouterHeroApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const _HeroHomePage(),
    ),
    GoRoute(
      path: '/drink/:id',
      name: 'drink',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final drink = kDemoDrinks.firstWhere(
          (d) => d.id == id,
          orElse: () => kDemoDrinks.first,
        );
        return _HeroDrinkDetailPage(drink: drink);
      },
    ),
  ],
);

class GoRouterHeroApp extends StatelessWidget {
  const GoRouterHeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter Hero',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

/// 一覧（ソース側 Hero）。
class _HeroHomePage extends StatelessWidget {
  const _HeroHomePage();

  static const double _thumbWidth = 96;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoRouter · Hero'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '下の画像をタップすると詳細へ遷移し、Hero が飛びます。',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final drink in kDemoDrinks)
                    _DrinkThumbnail(
                      drink: drink,
                      width: _thumbWidth,
                      onTap: () => context.pushNamed(
                        'drink',
                        pathParameters: {'id': drink.id},
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrinkThumbnail extends StatelessWidget {
  const _DrinkThumbnail({
    required this.drink,
    required this.width,
    required this.onTap,
  });

  final Drink drink;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DrinkHero(
          drink: drink,
          width: width,
          onTap: onTap,
        ),
        const SizedBox(height: 8),
        Text(
          drink.name,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}

/// 詳細（デスティネーション側 Hero）。戻るは [context.pop]。
class _HeroDrinkDetailPage extends StatelessWidget {
  const _HeroDrinkDetailPage({required this.drink});

  final Drink drink;

  static const double _heroWidth = 280;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(drink.name),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.lightBlueAccent.shade100,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.topCenter,
        child: DrinkHero(
          drink: drink,
          width: _heroWidth,
          onTap: () => context.pop(),
        ),
      ),
    );
  }
}
