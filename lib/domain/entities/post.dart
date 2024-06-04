// lib/domain/entities/post.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String content;
  final String? mediaUrl;
  final DateTime? timestamp;
  final String userId;
  final String userName;  // Nombre del usuario que publica
  final String userEmail;  // Correo electrónico del usuario

  Post({
    required this.id,
    required this.content,
    this.mediaUrl,
    this.timestamp,
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Post(
        id: doc.id,
        content: data['content'] ?? '',
        mediaUrl: data['mediaUrl'],
        timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
        userId: data['userId'] ?? '',
        userName: data['userName'] ?? '',
        userEmail: data['userEmail'] ?? 'no-email@provided.com'  // Asegúrate de que este campo está siendo almacenado y recuperado correctamente
    );
  }
}
