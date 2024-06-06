import 'dart:io';

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
        backgroundColor: Colors.purple,  // Cambiado de Colors.blue a Colors.purple
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
                onPressed: () => _pickMedia(context, 'image'),
                child: Text('Subir Imagen'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
              ),
              ElevatedButton(
                onPressed: () => _pickMedia(context, 'video'),
                child: Text('Subir Video'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
              ),
              ElevatedButton(
                onPressed: () => _pickMedia(context, 'audio'),
                child: Text('Subir Audio'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (postController.text.isNotEmpty) {
                authController.createPostWithMedia(postController.text, null);
                postController.clear();
              }
            },
            child: Text('Publicar Texto'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue,
            ),
          ),
          Expanded(
            child: PostsList(),
          ),
        ],
      ),
    );
  }

  void _pickMedia(BuildContext context, String mediaType) async {
    final XFile? mediaFile;
    if (mediaType == 'image') {
      mediaFile = await picker.pickImage(source: ImageSource.gallery);
      print("Imagen seleccionada: ${mediaFile?.path}");
    } else if (mediaType == 'video') {
      mediaFile = await picker.pickVideo(source: ImageSource.gallery);
      print("Video seleccionado: ${mediaFile?.path}");
    } else if (mediaType == 'audio') {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        mediaFile = XFile(file.path);
        print("Audio seleccionado: ${mediaFile.path}");
      } else {
        mediaFile = null;
        print("No se seleccionó ningún audio.");
      }
    } else {
      mediaFile = null;
    }

    if (mediaFile != null) {
      authController.createPostWithMedia(postController.text, mediaFile,
          isVideo: mediaType == 'video',
          isAudio: mediaType == 'audio');
      postController.clear();
    } else {
      print("No se seleccionó ningún archivo.");
    }
  }
}
