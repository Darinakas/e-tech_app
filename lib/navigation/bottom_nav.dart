import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screens/home_page.dart';
import '../screens/categories_page.dart';
import '../screens/favorites_page.dart';
import '../screens/cart_page.dart';
import '../screens/profile_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          HomePage(),
          CategoriesPage(),
          FavoritesPage(),
          CartPage(),
          ProfilePage(),
        ],
        physics: const BouncingScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey[600],
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ??
            theme.scaffoldBackgroundColor,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: t.homeTitle),
          BottomNavigationBarItem(icon: const Icon(Icons.category), label: t.categories),
          BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: t.favorites),
          BottomNavigationBarItem(icon: const Icon(Icons.shopping_cart), label: t.cart),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: t.profileTitle),
        ],
      ),
    );
  }
}
