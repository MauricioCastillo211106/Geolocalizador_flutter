// lib/ui/screens/posts_list.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post.dart';

class PostsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Post post = Post.fromFirestore(document);
            return ListTile(
              title: Text(post.content),
              subtitle: post.mediaUrl != null ? Image.network(post.mediaUrl!) : null,
              trailing: Text(post.timestamp.toString()),
            );
          }).toList(),
        );
      },
    );
  }
}
