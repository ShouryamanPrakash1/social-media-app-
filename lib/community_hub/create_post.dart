import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _postController = TextEditingController();

  void _submitPost() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _postController.text.trim().isNotEmpty) {
      await FirebaseFirestore.instance.collection('posts').add({
        'content': _postController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'likesCount': 0,
      });
      _postController.clear();
      Navigator.pop(context);  // Go back to feed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text("Post"),
            ),
          ],
        ),
      ),
    );
  }
}
