import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import 'profile_screen.dart';
import 'post_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_post_screen.dart';
import 'package:video_player/video_player.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {  final PostService _postService = PostService();

  Future<void> _refreshPosts() async{
    await _postService.getPosts();
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    print("Home screen: building");
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        leading: IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            if (user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: user.uid),
                ),
              );
            }
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: StreamBuilder<List<Post>>(
          stream: _postService.getPostsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No posts available'));
            } else {
              final posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Name and Roll Number
                          Text(
                            '${post.userName} - ${post.userRollNumber}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          // Post Content
                          Text(
                            post.content,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 8.0),
                          // Display Image
                          if (post.imageUrl != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Image.network(post.imageUrl!),
                            ),
                          // Display Video
                          if (post.videoUrl != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
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
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                            });
                                          },
                                          child: Icon(
                                            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }
                              ),
                            ),
                          // Timestamp
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
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreatePostScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      );
    }
}
