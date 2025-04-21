import '../models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createPost({
    required Post post,
    required String userName,
    required String userRollNumber,
    File? imageFile,
    File? videoFile,
  }) async {
    try {
      String? imageUrl;
      String? videoUrl;

      if (imageFile != null) {
        imageUrl = await _uploadFile(imageFile, 'images');
      }

      if (videoFile != null) {
        videoUrl = await _uploadFile(videoFile, 'videos');
      }

      final postData = {
        'userId': post.userId,
        'content': post.content,
        'userName': userName,
        'userRollNumber': userRollNumber,
        'timestamp': post.timestamp,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (videoUrl != null) 'videoUrl': videoUrl,
      };

      await _firestore.collection('posts').doc(post.id).set(postData);
    } catch (e) {
      print("Error creating post: $e");
      rethrow;
    }
  }

  Future<String> _uploadFile(File file, String type) async {
    final ref = _storage.ref().child('$type/${DateTime.now().millisecondsSinceEpoch}-${file.path.split('/').last}');
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() => {});
    return await snapshot.ref.getDownloadURL();
  }

  Stream<List<Post>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final imageUrl = data['imageUrl'] as String?;
              final videoUrl = data['videoUrl'] as String?;

              return Post(
                  id: doc.id,
                  userId: data['userId'] as String,

          userName: data['userName'] as String,
          userRollNumber: data['userRollNumber'] as String,
          content: data['content'] as String,
          imageUrl: imageUrl,
          videoUrl: videoUrl,
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList());
  }
  
}
