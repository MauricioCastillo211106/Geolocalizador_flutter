// lib/domain/entities/post.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String content;
  final String? mediaUrl;
  final DateTime? timestamp;
  final String userId;
  final String userName;  // Asegúrate de tener este campo
  final String? mediaType;

  Post({
    required this.id,
    required this.content,
    this.mediaUrl,
    this.timestamp,
    required this.userId,
    required this.userName,  // Asegúrate de inicializar este campo
    this.mediaType,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      content: data['content'] ?? '',
      mediaUrl: data['mediaUrl'],
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
      userId: data['userId'] ?? '',
      userName: data['username'] ?? 'Anonymous',  // Verifica que este campo se esté obteniendo correctamente
      mediaType: data['mediaType'],
    );
  }
}
