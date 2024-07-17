import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? _controller;
  Position? _currentPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getAndDisplayLocation();
  }

  Future<void> _getAndDisplayLocation() async {
    if (await _checkPermission()) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentPosition = position;
          _markers.add(Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(title: 'You are here'),
          ));
        });
        _controller?.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude), 15));
      } catch (e) {
        print('Error obtaining location: $e');
      }
    } else {
      print('Location permission not granted');
    }
  }

  Future<bool> _checkPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: (controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition!.latitude,
              _currentPosition!.longitude),
          zoom: 15,
        ),
        markers: _markers,
      ),
    );
  }
}
