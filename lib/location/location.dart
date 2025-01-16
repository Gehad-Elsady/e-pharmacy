import 'dart:async';

import 'package:e_pharmacy/Backend/firebase_functions.dart';
import 'package:e_pharmacy/Screens/cart/payment-scree.dart';
import 'package:e_pharmacy/Screens/history/historyscreen.dart';
import 'package:e_pharmacy/Screens/history/model/historymaodel.dart';
import 'package:e_pharmacy/location/model/locationmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Gps extends StatefulWidget {
  HistoryModel historymaodel;
  int totalPrice;

  Gps({required this.historymaodel, required this.totalPrice});

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(30.230125, 31.269013),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  State<Gps> createState() => _GpsState();
}

class _GpsState extends State<Gps> {
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  Location location = Location();
  LocationData? locationData;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.0596113, 31.1760624), // Default to Cairo, Egypt
    zoom: 18.0,
  );

  bool _serviceEnabled = true;

  @override
  void initState() {
    super.initState();
    canAccessLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GPS"),
        centerTitle: true,
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.hybrid,
        zoomControlsEnabled: false,
        cameraTargetBounds: CameraTargetBounds(
          LatLngBounds(
            northeast:
                LatLng(31.916667, 35.000000), // Top right corner of Egypt
            southwest:
                LatLng(22.000000, 25.000000), // Bottom left corner of Egypt
          ),
        ),
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('Proceed to Payment'),
        icon: const Icon(Icons.location_on_outlined),
      ),
    );
  }

  Future<void> canAccessLocation() async {
    bool permissionGranted = await isPermissionGranted();
    if (!permissionGranted) return;

    bool serviceEnabled = await isServicesEnabled();
    if (!serviceEnabled) return;

    locationData = await location.getLocation();
    if (locationData != null) {
      _initialPosition = CameraPosition(
        target: LatLng(locationData!.latitude!, locationData!.longitude!),
        zoom: 14.4746,
      );
      print(
          "------------------------------------------- ${locationData!.latitude} ${locationData!.longitude}");
      setState(() {});
      final GoogleMapController controller = await _controller.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
    }
  }

  Future<void> _goToTheLake() async {
    bool permissionGranted = await isPermissionGranted();
    if (!permissionGranted) return;

    bool serviceEnabled = await isServicesEnabled();
    if (!serviceEnabled) return;

    locationData = await location.getLocation();
    if (locationData != null) {
      _initialPosition = CameraPosition(
        target: LatLng(locationData!.latitude!, locationData!.longitude!),
        zoom: 14.4746,
      );
      print(
          "------------------------------------------- ${locationData!.latitude} ${locationData!.longitude}");

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Choose your payment method",
              style: TextStyle(fontSize: 18)),
          content:
              Text("The app provides both cash and online payment options."),
          actions: [
            TextButton(
              child: Text("Cash"),
              onPressed: () async {
                // Creating history model with updated location data
                HistoryModel data = HistoryModel(
                  paymentMethod: "cash",
                  items: widget.historymaodel.items,
                  userId: widget.historymaodel.userId,
                  locationModel: LocationModel(
                      latitude: locationData!.latitude!,
                      longitude: locationData!.longitude!),
                  totalPrice: widget.totalPrice,
                  orderStatus: "pending",
                );
                await FirebaseFunctions.orderHistory(data);

                Navigator.pushReplacementNamed(
                    context, HistoryScreen.routeName);
              },
            ),
            TextButton(
              child: Text("online payment"),
              onPressed: () {
                // Creating history model with updated location data
                HistoryModel data = HistoryModel(
                  paymentMethod: "online payment",
                  items: widget.historymaodel.items,
                  userId: widget.historymaodel.userId,
                  locationModel: LocationModel(
                      latitude: locationData!.latitude!,
                      longitude: locationData!.longitude!),
                  totalPrice: widget.totalPrice,
                  orderStatus: "pending",
                );

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        historymaodel: data,
                        totalPrice: widget.totalPrice,
                      ),
                    ));
              },
            ),
          ],
        ),
      );
    }
  }

  Future<bool> isPermissionGranted() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }
    return _permissionGranted == PermissionStatus.granted;
  }

  Future<bool> isServicesEnabled() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
    return _serviceEnabled;
  }
}
