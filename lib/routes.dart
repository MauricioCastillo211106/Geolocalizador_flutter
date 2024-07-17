import 'package:flutter/material.dart';
import 'ui/screens/home_page.dart';
import 'ui/screens/maps_screen.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    '/': (context) => HomeScreen(),
    '/maps': (context) => MapsScreen(),
    // Otras rutas...
  };
}
