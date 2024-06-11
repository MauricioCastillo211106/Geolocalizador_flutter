// lib/ui/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../controllers/auth_controller.dart';
import 'posts_list.dart';

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
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
          ),
        ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (postController.text.isNotEmpty) {
                    await authController.createPostWithMedia(postController.text, null);
                    postController.clear();
                  }
                },
                child: Text('Publicar Texto'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final XFile? mediaFile = await picker.pickImage(source: ImageSource.gallery);
                  if (mediaFile != null) {
                    await authController.createPostWithMedia(postController.text, mediaFile);
                    postController.clear();
                  }
                },
                child: Text('Subir Imagen'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final XFile? videoFile = await picker.pickVideo(source: ImageSource.gallery);
                  if (videoFile != null) {
                    await authController.createPostWithMedia(postController.text, videoFile, isVideo: true);
                    postController.clear();
                  }
                },
                child: Text('Subir Video'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.audio,
                  );
                  if (result != null && result.files.single.path != null) {
                    final file = XFile(result.files.single.path!);
                    await authController.createPostWithMedia(postController.text, file, isAudio: true);
                    postController.clear();
                  }
                },
                child: Text('Subir Audio'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
          Expanded(
            child: PostsList(), // Widget para mostrar las publicaciones existentes
          ),
        ],
      ),
    );
  }
}
