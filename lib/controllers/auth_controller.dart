import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void registerUser(String email, String password) async {
    try {
      print("Intentando registrar usuario con email: $email");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print("Usuario registrado exitosamente: ${userCredential.user!.uid}");
      // Aquí podrías redirigir al usuario a otra página o hacer algún otro procesamiento.
    } on FirebaseAuthException catch (e) {
      // Captura errores específicos de Firebase
      if (e.code == 'weak-password') {
        print('La contraseña proporcionada es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        print('El email ya está siendo utilizado por otra cuenta.');
      } else {
        print('Error al registrar usuario: ${e.message}');
      }
    } catch (e) {
      // Captura cualquier otro error que podría no ser de FirebaseAuth
      print('Error al registrar usuario: $e');
    }
  }
}
