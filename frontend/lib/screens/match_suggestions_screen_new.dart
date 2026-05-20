import 'package:flutter/material.dart';
import '../services/match_service.dart';
import '../services/connection_service.dart';

class MatchSuggestionsScreen extends StatefulWidget {
  const MatchSuggestionsScreen({super.key});

  @override
  State<MatchSuggestionsScreen> createState() => _MatchSuggestionsScreenState();
}

class _MatchSuggestionsScreenState extends State<MatchSuggestionsScreen> {
  final _searchController = TextEditingController();
  late Future<Map<String, dynamic>> _matchesFuture;
  List<dynamic> _matches = [];
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  bool _isLoadingConnection = false;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  void _loadMatches() {
    _matchesFuture = MatchService.getSuggestedUsers();
    _matchesFuture.then((result) {
      if (result['success']) {
        setState(() {
          _matches = result['matches'] ?? [];
        });
      }
    });
  }

  void _handleSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    MatchService.searchUsers(query).then((result) {
      if (result['success']) {
        setState(() {
          _searchResults = result['results'] ?? [];
        });
      }
    });
  }

  void _sendConnectionRequest(String userId, int index, bool isSearchResult) async {
    setState(() => _isLoadingConnection = true);

    final result = await ConnectionService.sendConnectionRequest(userId);

    setState(() => _isLoadingConnection = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
        ),
      );
      // Update UI to show request sent
      if (isSearchResult && _searchResults.isNotEmpty && index < _searchResults.length) {
        setState(() {
          _searchResults[index]['requestSent'] = true;
        });
      } else if (!isSearchResult && _matches.isNotEmpty && index < _matches.length) {
        setState(() {
          _matches[index]['requestSent'] = true;
        });
      }
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
        title: const Text('Discover'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search people by name or interests...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _isSearching = false;
                            _searchResults = [];
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _handleSearch,
            ),
          ),
          // Results
          Expanded(
            child: _isSearching ? _buildSearchResults() : _buildSuggestedMatches(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('No results found'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        final requestSent = user['requestSent'] ?? false;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: user['profileImage'] != null
                  ? NetworkImage(user['profileImage'])
                  : null,
              child: user['profileImage'] == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(user['userName'] ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user['age'] != null)
                  Text('${user['age']} years old'),
                if (user['occupation'] != null && user['occupation'].isNotEmpty)
                  Text(user['occupation']),
                if (user['commonInterests'] != null &&
                    (user['commonInterests'] as List).isNotEmpty)
                  Text(
                    '${user['matchScore']} common interests',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            trailing: requestSent
                ? const Chip(label: Text('Requested'))
                : ElevatedButton(
                    onPressed: _isLoadingConnection
                        ? null
                        : () => _sendConnectionRequest(user['userId'], index, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Connect',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            onTap: () => _showUserProfile(user),
          ),
        );
      },
    );
  }

  Widget _buildSuggestedMatches() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _matchesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!['success']) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_add, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                Text(
                  snapshot.data?['message'] ?? 'Failed to load matches',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _loadMatches();
                    });
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (_matches.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 80, color: Colors.blue),
                SizedBox(height: 20),
                Text('No matches found yet. Complete your profile with at least 4 interests!'),
              ],
            ),
          );
        }

          return ListView.builder(
          itemCount: _matches.length,
          itemBuilder: (context, index) {
            final match = _matches[index];
            final requestSent = match['requestSent'] ?? false;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: [
                  // Profile image
                  if (match['profileImage'] != null)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(match['profileImage']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with name and match score
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    match['userName'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (match['age'] != null)
                                    Text('${match['age']} years old'),
                                  if (match['occupation'] != null &&
                                      match['occupation'].isNotEmpty)
                                    Text(match['occupation']),
                                ],
                              ),
                            ),
                            // Match score
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${match['matchScore']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Text(
                                    'Match',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Location
                        if (match['location'] != null && match['location'].isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(match['location']),
                            ],
                          ),

                        // Bio
                        if (match['bio'] != null && match['bio'].isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            match['bio'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],

                        // Common interests
                        if (match['commonInterests'] != null &&
                            (match['commonInterests'] as List).isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: (match['commonInterests'] as List)
                                .take(3)
                                .map((interest) => Chip(
                                      label: Text(interest),
                                      backgroundColor: Colors.blue[100],
                                    ))
                                .toList(),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Connect button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: requestSent || _isLoadingConnection
                                ? null
                                : () => _sendConnectionRequest(match['userId'], index, false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              requestSent ? 'Request Sent' : 'Send Connection Request',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => _showUserProfile(match),
                            child: const Text('View Profile'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showUserProfile(dynamic user) {
    showBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user['userName'] ?? '',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (user['bio'] != null && user['bio'].isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text('About', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(user['bio']),
              ],
              if (user['interests'] != null &&
                  (user['interests'] as List).isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Interests', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (user['interests'] as List)
                      .map((interest) => Chip(label: Text(interest)))
                      .toList(),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
