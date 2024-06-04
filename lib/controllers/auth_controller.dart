import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void registerUser(String email, String password) async {
    try {
      print("Intentando registrar usuario con email: $email");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print("Usuario registrado exitosamente: ${userCredential.user!.uid}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('La contraseña proporcionada es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        print('El email ya está siendo utilizado por otra cuenta.');
      } else {
        print('Error al registrar usuario: ${e.message}');
      }
    } catch (e) {
      print('Error al registrar usuario: $e');
    }
  }

  void loginUser(String email, String password) async {
    try {
      print("Intentando iniciar sesión con email: $email");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("Usuario inició sesión exitosamente: ${userCredential.user!.uid}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No se encontró un usuario con ese email.');
      } else if (e.code == 'wrong-password') {
        print('Contraseña incorrecta proporcionada para ese usuario.');
      } else {
        print('Error al iniciar sesión: ${e.message}');
      }
    } catch (e) {
      print('Error al iniciar sesión: $e');
    }
  }
}
