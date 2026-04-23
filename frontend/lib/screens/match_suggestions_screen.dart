import 'package:flutter/material.dart';
import '../services/match_service.dart';
import '../models/match_model.dart';

class MatchSuggestionsScreen extends StatefulWidget {
  const MatchSuggestionsScreen({Key? key}) : super(key: key);

  @override
  State<MatchSuggestionsScreen> createState() => _MatchSuggestionsScreenState();
}

class _MatchSuggestionsScreenState extends State<MatchSuggestionsScreen> {
  late Future<Map<String, dynamic>> _matchesFuture;
  int _currentIndex = 0;
  List<Match> _matches = [];

  @override
  void initState() {
    super.initState();
    _matchesFuture = MatchService.getSuggestedUsers();
    _matchesFuture.then((result) {
      if (result['success']) {
        setState(() {
          _matches = result['matches'];
        });
      }
    });
  }

  void _onSwipeLeft() {
    if (_currentIndex < _matches.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No more matches! Check back later.')),
      );
    }
  }

  void _onSwipeRight() {
    // TODO: Save like in a future "likes"collection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You liked this person! 💕')),
    );
    _onSwipeLeft();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vibe Matches'),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
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
                        _matchesFuture = MatchService.getSuggestedUsers();
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
                  Icon(Icons.people_outline, size: 80, color: Colors.pink),
                  SizedBox(height: 20),
                  Text('No matches found yet. Complete your profile!'),
                ],
              ),
            );
          }

          if (_currentIndex >= _matches.length) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.done_all, size: 80, color: Colors.green),
                  SizedBox(height: 20),
                  Text('You\'ve seen all matches!'),
                ],
              ),
            );
          }

          final match = _matches[_currentIndex];

          return SingleChildScrollView(
            child: Column(
              children: [
                // Match card
                Card(
                  margin: const EdgeInsets.all(16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: match.profileImage != null
                              ? Image.network(
                                  match.profileImage!,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.person, size: 100),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name, age, location
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        match.userName,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (match.age != null)
                                        Text(
                                          '${match.age} years old',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                // Match score badge
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${match.matchScore}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
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
                            if (match.location.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(match.location),
                                ],
                              ),

                            const SizedBox(height: 12),

                            // Bio
                            if (match.bio.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'About',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(match.bio),
                                  const SizedBox(height: 12),
                                ],
                              ),

                            // Common interests & hobbies
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.pink[50],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '${match.commonInterests}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pink,
                                        ),
                                      ),
                                      const Text('Common Interests'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${match.commonHobbies}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pink,
                                        ),
                                      ),
                                      const Text('Common Hobbies'),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Interests
                            if (match.interests.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Interests',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: match.interests
                                        .map((interest) => Chip(
                                              label: Text(interest),
                                              backgroundColor: Colors.pink[100],
                                            ))
                                        .toList(),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),

                            // Hobbies
                            if (match.hobbies.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Hobbies',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: match.hobbies
                                        .map((hobby) => Chip(
                                              label: Text(hobby),
                                              backgroundColor: Colors.blue[100],
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _onSwipeLeft,
                        icon: const Icon(Icons.close),
                        label: const Text('Pass'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _onSwipeRight,
                        icon: const Icon(Icons.favorite),
                        label: const Text('Like'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Progress indicator
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '${_currentIndex + 1} / ${_matches.length}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
