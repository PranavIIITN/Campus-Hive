import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final PostService _postService = PostService();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final post = Post(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: user.uid,
          content: _contentController.text,
          timestamp: DateTime.now(),
        );
        try {
          await _postService.createPost(post);
          if (mounted) {
            Navigator.pop(context);
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating post: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Post Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createPost,
                child: const Text('Create Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}