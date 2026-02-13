import '../models/product.dart';

class FavoriteModel {
  static final List<Product> _favorites = [];

  static void toggle(Product product) {
    if (isFavorite(product)) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
  }

  static bool isFavorite(Product product) {
    return _favorites.any((p) => p.id == product.id);
  }

  static List<Product> get favorites => _favorites;
}
