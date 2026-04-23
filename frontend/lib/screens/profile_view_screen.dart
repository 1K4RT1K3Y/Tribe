import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../models/profile_model.dart';

class ProfileViewScreen extends StatefulWidget {
  final String userId;

  const ProfileViewScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService.getUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!['success']) {
            return Center(
              child: Text(snapshot.data?['message'] ?? 'Failed to load profile'),
            );
          }

          final Profile profile = snapshot.data!['profile'];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: profile.profileImage != null
                      ? Image.network(profile.profileImage!, fit: BoxFit.cover)
                      : const Icon(Icons.person, size: 100),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Verification
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User Profile',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                if (profile.verified)
                                  const Row(
                                    children: [
                                      Icon(Icons.verified, color: Colors.blue, size: 16),
                                      SizedBox(width: 4),
                                      Text('Verified'),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Location
                      if (profile.location.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(profile.location),
                            ],
                          ),
                        ),

                      // Age
                      if (profile.age != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              const Icon(Icons.cake, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text('${profile.age} years old'),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Bio
                      if (profile.bio.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('About',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            Text(profile.bio),
                            const SizedBox(height: 20),
                          ],
                        ),

                      // Interests
                      if (profile.interests.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Interests',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: profile.interests
                                  .map((interest) => Chip(label: Text(interest)))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),

                      // Hobbies
                      if (profile.hobbies.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hobbies',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: profile.hobbies
                                  .map((hobby) => Chip(label: Text(hobby)))
                                  .toList(),
                            ),
                          ],
                        ),
                    ],
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
