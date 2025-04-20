import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';
import '../services/post_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> posts = [];
  final PostService postService = PostService();

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    List<Post> fetchedPosts = await postService.getPosts();
    setState(() {
      posts = fetchedPosts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: posts.isEmpty
          ? const Center(
              child: Text('No posts available'),
            )
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(                  
                  key: ValueKey(posts[index].id),
                  post: posts[index],
                );
              },
            ),
    );
  }
}
