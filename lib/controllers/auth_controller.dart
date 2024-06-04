import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void registerUser(String email, String password, String username) async {
    try {
      print("Intentando registrar usuario con email: $email");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print("Usuario registrado exitosamente: ${userCredential.user!.uid}");

      // Almacenar información adicional del usuario en Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'username': username,  // Almacenar el nombre de usuario
      });

      Get.offAllNamed('/home');  // Redireccionar a HomePage después del registro
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
      Get.offAllNamed('/home');  // Redireccionar a HomePage después del inicio de sesión
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

  Future<void> createPostWithMedia(String content, XFile? mediaFile) async {
    try {
      String? mediaUrl;
      if (mediaFile != null) {
        String fileName = mediaFile.name;
        File file = File(mediaFile.path);
        String filePath = 'posts/${DateTime.now().millisecondsSinceEpoch}_$fileName';
        TaskSnapshot snapshot = await _storage.ref().child(filePath).putFile(file);
        mediaUrl = await snapshot.ref.getDownloadURL();
      }

      // Recuperar el nombre de usuario de Firestore
      var userDoc = await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
      String username = userDoc.data()?['username'] ?? 'Anónimo';

      // Crear una publicación con referencia al archivo subido y nombre de usuario
      await _firestore.collection('posts').add({
        'content': content,
        'mediaUrl': mediaUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': _auth.currentUser?.uid,
        'username': username,  // Añadir el nombre de usuario a la publicación
      });
      Get.back();
      Get.snackbar('Éxito', 'Publicación creada con éxito');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo crear la publicación: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
