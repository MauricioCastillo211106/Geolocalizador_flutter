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
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(post.userId).get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return CircularProgressIndicator();
                }
                String username = userSnapshot.data?['username'] ?? 'Anónimo'; // Asumiendo que 'username' está almacenado en Firestore
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
                            image: DecorationImage(
                              image: NetworkImage(post.mediaUrl!),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.content, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 10),
                            Text('Publicado por: $username', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                            if (post.timestamp != null)
                              Text('Publicado: ${post.timestamp}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
