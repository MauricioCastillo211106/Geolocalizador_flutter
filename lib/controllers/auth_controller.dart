// lib/controllers/auth_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Método para obtener el usuario actual
  User? get currentUser => _auth.currentUser;

  // Método para obtener el nombre de usuario actual
  Future<String> getUserName() async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) return 'Anonymous';
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc['username'] ?? 'Anonymous';
  }

  // Método para registrar un nuevo usuario con email, contraseña y nombre de usuario
  Future<void> registerUser(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Actualiza el perfil del usuario para incluir el nombre de usuario
      await userCredential.user!.updateDisplayName(username);

      // Almacenar información adicional del usuario en Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'username': username,  // Guardar el nombre de usuario
      });

      Get.offAllNamed('/home');  // Redireccionar a la página de inicio después del registro
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error de Registro', e.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }


  // Método para iniciar sesión con email y contraseña
  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed('/home');  // Redireccionar a la página de inicio después de iniciar sesión
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error de Inicio de Sesión', e.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/login');  // Redireccionar a la pantalla de login después de cerrar sesión
    } catch (e) {
      Get.snackbar('Error al cerrar sesión', 'No se pudo cerrar sesión: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }



  // Método para crear una publicación con un archivo multimedia opcional
  Future<void> createPostWithMedia(String content, XFile? mediaFile, {bool isVideo = false, bool isAudio = false}) async {
    try {
      String? mediaUrl;
      String? mediaType;

      if (mediaFile != null) {
        File file = File(mediaFile.path);
        String fileName = mediaFile.name;
        String filePath = (isVideo ? 'videos' : isAudio ? 'audios' : 'images') + '/${DateTime.now().millisecondsSinceEpoch}_$fileName';
        TaskSnapshot snapshot = await _storage.ref().child(filePath).putFile(file);
        mediaUrl = await snapshot.ref.getDownloadURL();
        mediaType = isVideo ? 'video' : isAudio ? 'audio' : 'image';
      }

      String userName = await getUserName();

      // Crear la publicación en Firestore
      await _firestore.collection('posts').add({
        'content': content,
        'mediaUrl': mediaUrl,
        'mediaType': mediaType,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': _auth.currentUser?.uid,
        'username': userName  // Guardar el nombre de usuario con el post
      });

      Get.back();
      Get.snackbar('Éxito', 'Publicación creada con éxito');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo crear la publicación: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
  }
