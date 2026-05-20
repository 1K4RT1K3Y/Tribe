import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../models/profile_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _bioController;
  late TextEditingController _ageController;
  late TextEditingController _locationController;
  
  List<String> _interests = [];
  List<String> _hobbies = [];
  bool _isLoading = false;

  final List<String> _suggestedInterests = [
    'Sports', 'Music', 'Art', 'Technology', 'Books',
    'Travel', 'Food', 'Movies', 'Gaming', 'Fitness',
    'Photography', 'Cooking', 'Dancing', 'Hiking', 'Reading',
  ];

  final List<String> _suggestedHobbies = [
    'Painting', 'Drawing', 'Writing', 'Photography', 'Gaming',
    'Cooking', 'Gardening', 'Yoga', 'Meditation', 'Running',
    'Swimming', 'Cycling', 'Hiking', 'Camping',
  ];

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController();
    _ageController = TextEditingController();
    _locationController = TextEditingController();
    _loadProfile();
  }

  void _loadProfile() async {
    final result = await ProfileService.getMyProfile();
    if (result['success']) {
      final Profile profile = result['profile'];
      setState(() {
        _bioController.text = profile.bio;
        _ageController.text = profile.age?.toString() ?? '';
        _locationController.text = profile.location;
        _interests = List.from(profile.interests);
        _hobbies = List.from(profile.hobbies);
      });
    }
  }

  void _handleSaveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final result = await ProfileService.updateProfile(
        bio: _bioController.text,
        interests: _interests,
        hobbies: _hobbies,
        age: _ageController.text.isEmpty ? null : int.parse(_ageController.text),
        location: _locationController.text,
      );

      setState(() => _isLoading = false);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Failed to update profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Tell us about yourself...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your age';
                    }
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
                    hintText: 'Your location',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
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

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSaveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blue,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
