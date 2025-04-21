import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final PostService _postService = PostService();
  File? _imageFile;
  File? _videoFile;
  final UserService _userService = UserService();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final userData = await _userService.getUser(user.uid);
          if (userData.name != null && userData.rollNo != null) {
            final post = Post(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              userId: user.uid,
              userName: userData.name!,
              userRollNumber: userData.rollNo!,
              content: _contentController.text,
              timestamp: DateTime.now(),
            );
            await _postService.createPost(
              post: post,
              userName: userData.name!,
              userRollNumber: userData.rollNo!,
              imageFile: _imageFile,
              videoFile: _videoFile,
            );
            if (mounted) {
              Navigator.pop(context);
            }
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          _imageFile = File(pickedFile.path);
                        });
                      }
                    },
                    child: const Text('Pick Image'),
                  ),
                  if (_imageFile != null)
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          _videoFile = File(pickedFile.path);
                        });
                      }
                    },
                    child: const Text('Pick Video'),
                  ),
                  if (_videoFile != null)
                    const Text('Video Selected'),
                ],
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
