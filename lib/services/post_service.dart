import '../models/post.dart';

class PostService {
  PostService();

  Future<void> createPost(Post post) async {
    print('Creating post: ${post.id}');
    // Placeholder for creating a post in Firestore
  }

  Future<Post> getPost(String id) async {
    print('Getting post: $id');
    return Post(
      id: id,
      userId: 'user1',
      content: 'Post 1 content',
      timestamp: DateTime.now(),
    );
  }

  Future<List<Post>> getPosts() async {
    print('Getting all posts');
    return [
      Post(
        id: '1',
        userId: 'user1',
        content: 'Post 1 content',
        timestamp: DateTime.now(),
      ),
      Post(
        id: '2',
        userId: 'user2',
        content: 'Post 2 content',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Post(
        id: '3',
        userId: 'user3',
        content: 'Post 3 content',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Post(
        id: '4',
        userId: 'user1',
        content: 'Post 4 content',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Post(
        id: '5',
        userId: 'user4',
        content: 'Post 5 content',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  Future<void> updatePost(Post post) async {
    print('Updating post: ${post.id}');
    // Placeholder for updating the post in Firestore
  }

  Future<void> deletePost(String id) async {
    print('Deleting post: $id');
    // Placeholder for deleting the post from Firestore
  }
}
