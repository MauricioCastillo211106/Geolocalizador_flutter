// lib/ui/screens/posts_list.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post.dart';
import '../widgets/audio_player_widget.dart';
import '../widgets/video_widget.dart';


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
            return Card(
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.mediaUrl != null)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: post.mediaType == 'image'
                            ? DecorationImage(
                          image: NetworkImage(post.mediaUrl!),
                          fit: BoxFit.cover,
                        )
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: post.mediaType == 'video'
                          ? VideoWidget(url: post.mediaUrl!)
                          : post.mediaType == 'audio'
                          ? AudioPlayerWidget(url: post.mediaUrl!)
                          : null,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.content, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 10),
                        Text('Publicado por: ${post.userName}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                        if (post.timestamp != null)
                          Text('Publicado: ${post.timestamp}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
