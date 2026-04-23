import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../models/profile_model.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String userId;

  const ProfileSetupScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  List<String> _interests = [];
  List<String> _hobbies = [];
  bool _isLoading = false;

  final List<String> _suggestedInterests = [
    'Sports',
    'Music',
    'Art',
    'Technology',
    'Books',
    'Travel',
    'Food',
    'Movies',
    'Gaming',
    'Fitness',
    'Photography',
    'Cooking',
    'Dancing',
    'Hiking',
    'Reading',
  ];

  final List<String> _suggestedHobbies = [
    'Painting',
    'Drawing',
    'Writing',
    'Photography',
    'Gaming',
    'Cooking',
    'Gardening',
    'Yoga',
    'Meditation',
    'Running',
    'Swimming',
    'Cycling',
    'Hiking',
    'Camping',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bio
                const Text('Bio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _bioController,
                  decoration: InputDecoration(
                    hintText: 'Tell us about yourself...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    maxLines: 4,
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a bio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Age
                const Text('Age', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Your age',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter your age';
                    final age = int.tryParse(value!);
                    if (age == null || age < 13 || age > 120) {
                      return 'Age must be between 13 and 120';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Location
                const Text('Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'City, Country',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 20),

                // Interests
                const Text('Interests (Select up to 20)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _suggestedInterests
                      .map((interest) => FilterChip(
                            label: Text(interest),
                            selected: _interests.contains(interest),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  if (_interests.length < 20) {
                                    _interests.add(interest);
                                  }
                                } else {
                                  _interests.remove(interest);
                                }
                              });
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),

                // Hobbies
                const Text('Hobbies (Select up to 20)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _suggestedHobbies
                      .map((hobby) => FilterChip(
                            label: Text(hobby),
                            selected: _hobbies.contains(hobby),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  if (_hobbies.length < 20) {
                                    _hobbies.add(hobby);
                                  }
                                } else {
                                  _hobbies.remove(hobby);
                                }
                              });
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleProfileSetup,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.pink,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white),
                          )
                        : const Text('Create Profile',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleProfileSetup() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_interests.isEmpty || _hobbies.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one interest and hobby')),
        );
        return;
      }

      setState(() => _isLoading = true);

      final result = await ProfileService.createProfile(
        bio: _bioController.text,
        interests: _interests,
        hobbies: _hobbies,
        age: int.parse(_ageController.text),
        location: _locationController.text,
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
  }

  @override
  void dispose() {
    _bioController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
