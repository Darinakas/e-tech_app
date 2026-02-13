import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../models/product.dart';
import '../providers/theme_provider.dart';
import '../widgets/product_card.dart';
import 'item_detail_page.dart';
import '../components/hover_animated_filter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String selectedCategory = 'all';
  List<Product> _allProducts = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortOption = 'alphabetical'; // Use keys, not localized text

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await DatabaseHelper.instance.readAllProducts();
    setState(() {
      _allProducts = products;
    });
  }

  List<Product> _filteredProducts() {
    List<Product> filtered = selectedCategory == 'all'
        ? _allProducts
        : _allProducts.where((p) => p.category.toLowerCase() == selectedCategory).toList();

    filtered = filtered
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    if (_sortOption == 'alphabetical') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortOption == 'price') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    final categories = {
      'all': loc.categoryAll,
      'phones': loc.categoryPhones,
      'laptops': loc.categoryLaptops,
      'accessories': loc.categoryAccessories,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.categories),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                  key: ValueKey(themeProvider.isDarkMode),
                ),
              ),
              onPressed: () {
                final nextIndex = (themeProvider.themeIndex + 1) % 3;
                themeProvider.setTheme(nextIndex);
              },

            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: theme.textTheme.bodyMedium?.color),
              decoration: InputDecoration(
                labelText: loc.search,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.sort, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Text(
                      loc.sortBy,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey.shade400,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _sortOption,
                      dropdownColor: theme.cardColor,
                      style: theme.textTheme.bodyMedium,
                      items: [
                        DropdownMenuItem(value: 'alphabetical', child: Text(loc.sortAlphabetical)),
                        DropdownMenuItem(value: 'price', child: Text(loc.sortPrice)),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sortOption = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (_, index) {
                final key = categories.keys.elementAt(index);
                final label = categories.values.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  child: HoverAnimatedFilter(
                    label: label,
                    isSelected: selectedCategory == key,
                    onTap: () => setState(() => selectedCategory = key),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _filteredProducts().length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 3 / 4,
              ),
              itemBuilder: (_, index) {
                final product = _filteredProducts()[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ItemDetailPage(product: product),
                      ),
                    );
                  },
                  child: ProductCard(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
