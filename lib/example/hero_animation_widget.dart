import 'package:flutter/material.dart';

/// 飲み物1件（Hero の [Drink.id] がタグになる）。
class Drink {
  const Drink({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String imageUrl;
}

/// デモ用の画像 URL。本番では自前の CDN やアセットに差し替えてください。
const List<Drink> kDemoDrinks = [
  Drink(
    id: 'wine',
    name: 'ワイン',
    imageUrl:
        'assets/images/wine.png',
  ),
  Drink(
    id: 'tea',
    name: '紅茶',
    imageUrl:
        'assets/images/tea.png',
  ),
  Drink(
    id: 'coffee',
    name: 'コーヒー',
    imageUrl:
        'assets/images/coffee.png',
  ),
];

/// 公式サンプルの [PhotoHero](https://docs.flutter.dev/ui/animations/hero-animations#photohero-class)
/// と同様。画像のみ [Image.network] に差し替え。
class DrinkHero extends StatelessWidget {
  const DrinkHero({
    super.key,
    required this.drink,
    required this.width,
    this.onTap,
  });

  final Drink drink;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: drink.id,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(
              drink.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return SizedBox(
                  height: width,
                  width: width,
                  child: Icon(
                    Icons.local_drink_outlined,
                    size: width * 0.4,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// 一覧（ソースルート）。下部に 3 サムネ、タップで詳細へ。
class HeroAnimationDemo extends StatelessWidget {
  const HeroAnimationDemo({super.key});

  static const double _thumbWidth = 96;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Animation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '下の画像をタップすると、上に移動しながら拡大します。',
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
                      onTap: () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (context) => DrinkDetailPage(drink: drink),
                          ),
                        );
                      },
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

/// 詳細（デスティネーションルート）。上部に大きく表示、タップで戻る。
class DrinkDetailPage extends StatelessWidget {
  const DrinkDetailPage({super.key, required this.drink});

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
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
