import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreMap extends StatefulWidget {
  const StoreMap({super.key});

  @override
  State<StoreMap> createState() => _StoreMapState();
}

class _StoreMapState extends State<StoreMap> {
  late GoogleMapController mapController;

  final LatLng _storeLocation = const LatLng(51.1605, 71.4704);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _storeLocation,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('store'),
            position: _storeLocation,
            infoWindow: const InfoWindow(
              title: 'E-Tech Store',
              snippet: 'Welcome to our shop!',
            ),
          )
        },
      ),
    );
  }
}
