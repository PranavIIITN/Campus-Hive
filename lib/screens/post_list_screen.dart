import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/post_service.dart';
import '../models/post.dart';
import 'create_post_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
      ),
      body: StreamBuilder<List<Post>>(
        stream: _postService.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${post.userName} (${post.userRollNumber})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          post.content,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        if (post.imageUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Image.network(post.imageUrl!),
                          ),
                        if (post.videoUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                late VideoPlayerController _controller;
                                bool _isInitialized = false;

                                Future<void> initializeVideoPlayer() async {
                                  _controller = VideoPlayerController.networkUrl(Uri.parse(post.videoUrl!));
                                  await _controller.initialize();
                                  setState(() {
                                    _isInitialized = true;
                                  });
                                  _controller.setLooping(true);
                                }

                                if (!_isInitialized) {
                                  initializeVideoPlayer();
                                  return const Text('Loading Video...');
                                } else {
                                  return Column(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: _controller.value.aspectRatio,
                                        child: VideoPlayer(_controller),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),


                        const SizedBox(height: 8.0),
                        Text(
                          'Posted on: ${post.timestamp.toString()}',
                          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}