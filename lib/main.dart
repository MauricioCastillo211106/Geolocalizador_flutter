import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:social_red/ui/screens/Login_Screen.dart';
import 'package:social_red/ui/screens/home_page.dart';
import 'ui/screens/register_screen.dart';
import 'controllers/auth_controller.dart'; // Asegúrate de importar el AuthController

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    // Puedes usar un proveedor `ReCaptchaEnterpriseProvider` como argumento para `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // El proveedor predeterminado para Android es el proveedor Play Integrity. Puedes usar el "AndroidProvider" para elegir
    // tu proveedor preferido. Elige entre:
    // 1. Proveedor de depuración
    // 2. Proveedor Safety Net
    // 3. Proveedor Play Integrity
    androidProvider: AndroidProvider.debug,
    // El proveedor predeterminado para iOS/macOS es el proveedor Device Check. Puedes usar el "AppleProvider" para elegir
    // tu proveedor preferido. Elige entre:
    // 1. Proveedor de depuración
    // 2. Proveedor Device Check
    // 3. Proveedor App Attest
    // 4. Proveedor App Attest con fallback al proveedor Device Check (App Attest provider solo está disponible en iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );

  // Inicializamos el AuthController al inicio de la aplicación
  Get.put(AuthController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Social App',
      initialRoute: '/',  // Ruta inicial
      getPages: [
        GetPage(name: '/', page: () => RegisterScreen()),  // Pantalla de registro
        GetPage(name: '/login', page: () => LoginScreen()),  // Pantalla de inicio de sesión
        GetPage(name: '/home', page: () => HomePage()),  // Pantalla de inicio
      ],
    );
  }
}
