import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorite_model.dart';
import '../providers/theme_provider.dart';
import '../widgets/product_card.dart';
import 'item_detail_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoriteModel.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favorites),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => IconButton(
              icon: Icon(
                themeProvider.isDarkMode
                    ? Icons.wb_sunny
                    : Icons.nightlight_round,
              ),
              onPressed: () {
                final nextIndex = (themeProvider.themeIndex + 1) % 3;
                themeProvider.setTheme(nextIndex);
              },

            ),
          ),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
        child: Text(AppLocalizations.of(context)!.noFavorites),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: favorites.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (_, index) {
          final product = favorites[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ItemDetailPage(product: product)),
              );
            },
            child: ProductCard(product: product),
          );
        },
      ),
    );
  }
}
