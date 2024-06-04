import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/auth_controller.dart';
import 'posts_list.dart'; // Asegúrate de que la importación es correcta

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
        backgroundColor: Colors.purple,  // Asegúrate de que esto coincide con las pantallas de registro y login.
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
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
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
              foregroundColor: Colors.white,
              backgroundColor: Colors.purple, // Cambiado para mantener la coherencia con AppBar
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
          Expanded(
            child: PostsList(), // Widget para mostrar las publicaciones existentes
          ),
        ],
      ),
    );
  }
}
