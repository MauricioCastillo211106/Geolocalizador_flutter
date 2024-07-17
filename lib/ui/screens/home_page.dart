import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;

  Future<void> _getAndUploadLocation() async {
    if (await _checkPermission()) {
      try {
        Position position = await _getGeoLocation();
        setState(() {
          _currentPosition = position;
        });
        _uploadLocationToFirebase(position);
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

  Future<Position> _getGeoLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
  void _uploadLocationToFirebase(Position position) {
    final databaseReference = FirebaseDatabase.instance.ref();

    databaseReference.child("location").push().set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now().toIso8601String()
    }).then((_) {
      print('Location uploaded successfully');
    }).catchError((error) {
      print('Failed to upload location: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocation to Firebase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _currentPosition == null
                ? Text('No location data')
                : Text(
                'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getAndUploadLocation,
              child: Text('Get Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/maps');
              },
              child: Text('Show on Map'),
            ),
          ],
        ),
      ),
    );
  }
}
