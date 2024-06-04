// lib/domain/entities/post.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String content;
  final String? mediaUrl;
  final DateTime? timestamp;
  final String userId;

  Post({required this.id, required this.content, this.mediaUrl, this.timestamp, required this.userId});

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Post(
        id: doc.id,
        content: data['content'] ?? '',
        mediaUrl: data['mediaUrl'],
        timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
        userId: data['userId'] ?? ''
    );
  }
}
