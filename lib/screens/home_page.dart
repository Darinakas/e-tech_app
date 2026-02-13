import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../models/product.dart';
import '../providers/theme_provider.dart';
import '../widgets/product_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _products = [];
  late GoogleMapController _mapController;
  LatLng? _userLocation;

  final LatLng _aituLocation = const LatLng(51.090548, 71.418523);
  final LatLng _bayterekLocation = const LatLng(51.128055, 71.430417);
  final LatLng _khanShatyrLocation = const LatLng(51.132259, 71.403187);

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _setInitialMarkers();
    _getUserLocation();
  }

  Future<void> _loadProducts() async {
    final products = await DatabaseHelper.instance.readAllProducts();
    setState(() {
      _products = products;
    });
  }

  void _setInitialMarkers() {
    _markers.addAll({
      Marker(
        markerId: const MarkerId('aitu'),
        position: _aituLocation,
        infoWindow: const InfoWindow(title: 'Astana IT University'),
        onTap: () => _animateToMarker(_aituLocation),
      ),
      Marker(
        markerId: const MarkerId('bayterek'),
        position: _bayterekLocation,
        infoWindow: const InfoWindow(title: 'Bayterek Monument'),
        onTap: () => _animateToMarker(_bayterekLocation),
      ),
      Marker(
        markerId: const MarkerId('khan_shatyr'),
        position: _khanShatyrLocation,
        infoWindow: const InfoWindow(title: 'Khan Shatyr Mall'),
        onTap: () => _animateToMarker(_khanShatyrLocation),
      ),
    });
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng userLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _userLocation = userLatLng;
      _markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: userLatLng,
          infoWindow: const InfoWindow(title: 'You are here'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fitAllMarkers();
  }

  void _fitAllMarkers() {
    final bounds = LatLngBounds(
      southwest: const LatLng(51.0840, 71.4000),
      northeast: const LatLng(51.1350, 71.4400),
    );
    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

  void _animateToMarker(LatLng target) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 16),
      ),
    );
  }

  void _goToUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng userLatLng = LatLng(position.latitude, position.longitude);

    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: userLatLng, zoom: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homeTitle),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              ),
              onPressed: () {
                final nextIndex = (themeProvider.themeIndex + 1) % 3;
                themeProvider.setTheme(nextIndex);
              },

            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: theme.scaffoldBackgroundColor,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Image.asset('assets/logo.png', height: 300),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to E-Tech Store!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover the best electronics at unbeatable prices.\nShop smartphones, laptops, accessories and more!',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Google Map
                  SizedBox(
                    height: 300,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: _aituLocation,
                              zoom: 13.5,
                            ),
                            markers: _markers,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            rotateGesturesEnabled: true,
                          ),
                        ),
                        Positioned(
                          bottom: 100,
                          right: 7,
                          child: FloatingActionButton.small(
                            heroTag: 'my_location',
                            onPressed: _goToUserLocation,
                            child: const Icon(Icons.my_location),
                            tooltip: 'Go to my location',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),

              // Features Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _FeatureItem(icon: Icons.local_shipping, text: 'Fast Delivery'),
                  _FeatureItem(icon: Icons.support_agent, text: '24/7 Support'),
                  _FeatureItem(icon: Icons.security, text: 'Secure Payment'),
                ],
              ),
              const SizedBox(height: 24),

              // Products Section
              if (_products.isEmpty)
                Column(
                  children: [
                    Text(
                      'No products available yet.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              else
                Column(
                  children: _products
                      .map((product) => ProductCard(product: product))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 36, color: Colors.blueAccent),
        const SizedBox(height: 8),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
