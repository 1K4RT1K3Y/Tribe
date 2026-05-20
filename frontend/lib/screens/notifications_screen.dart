import 'package:flutter/material.dart';
import '../services/connection_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _connectionRequests = [];
  bool _isLoadingRequests = true;
  bool _isProcessing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _loadConnectionRequests();
  }

  Future<void> _loadConnectionRequests() async {
    setState(() {
      _isLoadingRequests = true;
      _error = null;
    });

    final result = await ConnectionService.getPendingRequests();

    if (mounted) {
      setState(() {
        if (result['success']) {
          _connectionRequests = result['requests'] ?? [];
          _error = null;
        } else {
          _error = result['message'] ?? 'Failed to load requests';
          _connectionRequests = [];
        }
        _isLoadingRequests = false;
      });
    }
  }

  Future<void> _acceptRequest(String requestId, int index) async {
    setState(() => _isProcessing = true);

    final result = await ConnectionService.acceptConnectionRequest(requestId);

    setState(() => _isProcessing = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection accepted!'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        _connectionRequests.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectRequest(String requestId, int index) async {
    setState(() => _isProcessing = true);

    final result = await ConnectionService.rejectConnectionRequest(requestId);

    setState(() => _isProcessing = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection declined'),
          backgroundColor: Colors.orange,
        ),
      );
      setState(() {
        _connectionRequests.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConnectionRequests,
          ),
        ],
      ),
      body: _isLoadingRequests
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        _error ?? 'Error loading notifications',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadConnectionRequests,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _connectionRequests.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none,
                              size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No pending connection requests',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'When someone sends you a connection request, it will appear here',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadConnectionRequests,
                      child: ListView.builder(
                        itemCount: _connectionRequests.length,
                        itemBuilder: (context, index) {
                          final request = _connectionRequests[index];
                          final senderProfile = request['senderProfile'];
                          final sender = request['senderId'];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      // Avatar
                                      CircleAvatar(
                                        radius: 32,
                                        backgroundImage: senderProfile?['profileImage'] != null
                                            ? NetworkImage(senderProfile['profileImage'])
                                            : null,
                                        child: senderProfile?['profileImage'] == null
                                            ? const Icon(Icons.person)
                                            : null,
                                      ),
                                      const SizedBox(width: 16),
                                      // User info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              sender['name'] ?? 'Unknown',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (senderProfile?['occupation'] != null &&
                                                senderProfile['occupation'].isNotEmpty)
                                              Text(
                                                senderProfile['occupation'],
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            if (senderProfile?['bio'] != null &&
                                                senderProfile['bio'].isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Text(
                                                  senderProfile['bio'],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Common interests
                                if (senderProfile?['interests'] != null &&
                                    (senderProfile['interests'] as List).isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Interests',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: (senderProfile['interests'] as List)
                                              .take(4)
                                              .map((interest) => Chip(
                                                    label: Text(
                                                      interest,
                                                      style: const TextStyle(fontSize: 11),
                                                    ),
                                                    backgroundColor: Colors.blue[100],
                                                    padding: EdgeInsets.zero,
                                                  ))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                // Action buttons
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: _isProcessing
                                              ? null
                                              : () => _rejectRequest(request['_id'], index),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Colors.red),
                                          ),
                                          child: const Text(
                                            'Decline',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: _isProcessing
                                              ? null
                                              : () => _acceptRequest(request['_id'], index),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                          ),
                                          child: const Text(
                                            'Accept',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}