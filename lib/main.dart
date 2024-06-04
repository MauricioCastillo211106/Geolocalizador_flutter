import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:social_red/ui/screens/Login_Screen.dart';
import 'package:social_red/ui/screens/home_page.dart';
import 'ui/screens/register_screen.dart';  // Asegúrate de que la ruta sea correcta

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RedBase',
      initialRoute: '/',  // Ruta inicial
      getPages: [
        GetPage(name: '/', page: () => RegisterScreen()),  // Define la pantalla de registro
        GetPage(name: '/login', page: () => LoginScreen()),  // Define la pantalla de inicio de sesión
        GetPage(name: '/home', page: () => HomePage()),

        // Puedes añadir más rutas aquí si es necesario
      ],
    );
  }
}