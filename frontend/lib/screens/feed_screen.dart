import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../models/post_model.dart';
import 'create_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<Map<String, dynamic>> _feedFuture;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _feedFuture = PostService.getFeed(page: _currentPage);
    _scrollController.addListener(_loadMore);
  }

  void _loadMore() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      setState(() {
        _currentPage++;
        _feedFuture = PostService.getFeed(page: _currentPage);
      });
    }
  }

  void _refresh() {
    setState(() {
      _currentPage = 1;
      _feedFuture = PostService.getFeed(page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tribe Feed'),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _feedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!['success']) {
            return Center(
              child: Text(snapshot.data?['message'] ?? 'Failed to load feed'),
            );
          }

          final posts = snapshot.data!['posts'] as List<Post>;

          if (posts.isEmpty) {
            return const Center(
              child: Text('No posts available'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: posts[index], onPostUpdated: _refresh);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          ).then((_) => _refresh());
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onPostUpdated;

  const PostCard({
    Key? key,
    required this.post,
    required this.onPostUpdated,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Post _post;
  bool _isLiking = false;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  void _toggleLike() async {
    setState(() => _isLiking = true);
    final result = await PostService.likePost(_post.id);
    setState(() => _isLiking = false);

    if (result['success']) {
      setState(() {
        _post = result['post'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _post.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'just now',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(_post.content),
          ),

          // Post image
          if (_post.image != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Image.network(_post.image!, fit: BoxFit.cover),
            ),

          // Likes & comments count
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text('${_post.likesCount} likes'),
                const SizedBox(width: 20),
                Text('${_post.commentsCount} comments'),
              ],
            ),
          ),

          // Action buttons
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: _isLiking ? null : _toggleLike,
                  icon: Icon(
                    Icons.favorite,
                    color: _post.likes.contains('currentUserId') ? Colors.red : Colors.grey,
                  ),
                  label: const Text('Like'),
                ),
                TextButton.icon(
                  onPressed: () {
                    showCommentDialog(context, _post.id);
                  },
                  icon: const Icon(Icons.comment, color: Colors.grey),
                  label: const Text('Comment'),
                ),
              ],
            ),
          ),

          // Comments preview
          if (_post.comments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _post.comments.take(2).map((comment) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '${comment.userName}: ${comment.text}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  void showCommentDialog(BuildContext context, String postId) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(hintText: 'Write a comment...'),
          minLines: 3,
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final result = await PostService.addComment(
                postId: postId,
                text: commentController.text,
              );

              if (result['success']) {
                setState(() {
                  _post = result['post'];
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
