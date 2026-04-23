import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe/models/message_model.dart';
import 'package:vibe/providers/auth_provider.dart';
import 'package:vibe/screens/chat_screen.dart';
import 'package:vibe/services/message_service.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Map<String, dynamic>> _chatList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadChatList();
  }

  Future<void> _loadChatList() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final chatList = await MessageService.getChatList();

      setState(() {
        _chatList = chatList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChatList,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $_error',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadChatList,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _chatList.isEmpty
                  ? const Center(
                      child: Text(
                        'No conversations yet.\nStart matching to begin chatting!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadChatList,
                      child: ListView.builder(
                        itemCount: _chatList.length,
                        itemBuilder: (context, index) {
                          final chat = _chatList[index];
                          return _buildChatListItem(chat);
                        },
                      ),
                    ),
    );
  }

  Widget _buildChatListItem(Map<String, dynamic> chat) {
    final lastMessage = chat['lastMessage'] as Map<String, dynamic>;
    final unreadCount = chat['unreadCount'] as int;
    final username = chat['username'] as String;
    final profilePicture = chat['profilePicture'] as String?;

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: profilePicture != null
            ? NetworkImage(profilePicture)
            : null,
        child: profilePicture == null
            ? Text(username[0].toUpperCase())
            : null,
      ),
      title: Text(
        username,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        lastMessage['content'] ?? 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: unreadCount > 0 ? Colors.black : Colors.grey,
          fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(DateTime.parse(lastMessage['createdAt'])),
            style: TextStyle(
              fontSize: 12,
              color: unreadCount > 0 ? Colors.black : Colors.grey,
            ),
          ),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              userId: chat['userId'],
              username: username,
              profilePicture: profilePicture,
            ),
          ),
        ).then((_) => _loadChatList()); // Refresh when returning
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}