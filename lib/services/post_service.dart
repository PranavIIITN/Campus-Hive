import '../models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPost(Post post) async {
    try {
      await _firestore.collection('posts').doc(post.id).set({
        'userId': post.userId,
        'content': post.content,
        'timestamp': post.timestamp,
      });
    } catch (e) {
      print("Error creating post: $e");
      rethrow;
    }
  }
  
  Future<List<Post>> getAllPosts() async {
    try {
      final querySnapshot = await _firestore.collection('posts').orderBy('timestamp', descending: true).get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Post(
          id: doc.id,
          userId: data['userId'] as String,
          content: data['content'] as String,
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      print("Error getting posts: $e");
      return [];
    }
  }
  
}
