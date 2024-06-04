import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/auth_controller.dart';


class HomePage extends StatelessWidget {
  final AuthController authController = Get.find();
  final TextEditingController postController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: postController,
              decoration: InputDecoration(
                labelText: '¿Qué estás pensando?',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final XFile? mediaFile = await picker.pickImage(source: ImageSource.gallery);
              if (postController.text.isNotEmpty || mediaFile != null) {
                authController.createPostWithMedia(postController.text, mediaFile);
                postController.clear();
              }
            },
            child: Text('Publicar'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue,
            ),
          ),
          // Widget para mostrar las publicaciones existentes
        ],
      ),
    );
  }
}
