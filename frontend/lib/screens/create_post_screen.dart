import 'package:flutter/material.dart';
import '../services/post_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handlePost,
            child: Text(
              'Post',
              style: TextStyle(
                color: _isLoading ? Colors.grey : Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // User avatar
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Public',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Post content input
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                ),
                maxLines: null,
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.image, color: Colors.pink),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.emoji_emotions, color: Colors.pink),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.location_on, color: Colors.pink),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePost() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await PostService.createPost(
      content: _contentController.text,
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
