import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  final _occupationController = TextEditingController();
  final List<String> _interests = [];
  final List<String> _hobbies = [];
  String? _selectedGender;
  String? _selectedRelationshipStatus;
  bool _isLoading = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Non-binary', 'Other', 'Prefer not to say'];
  final List<String> _relationshipOptions = ['Single', 'In a relationship', 'Married', 'Prefer not to say'];

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
    'Writing',
    'Fashion',
    'Meditation',
    'Volunteering',
    'Entrepreneurship',
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
    'Traveling',
    'Reading',
    'Blogging',
    'Podcasting',
    'Fitness',
    'Coding',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        elevation: 0,
        automaticallyImplyLeading: false,
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
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tell us about yourself...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
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
                    if (value != null && value.isNotEmpty) {
                      final age = int.tryParse(value);
                      if (age == null || age < 13 || age > 120) {
                        return 'Age must be between 13 and 120';
                      }
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

                // Occupation
                const Text('Occupation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _occupationController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Software Engineer, Teacher, etc.',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.work),
                  ),
                ),
                const SizedBox(height: 20),

                // Gender
                const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _selectedGender,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  hint: const Text('Select your gender'),
                  items: _genderOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Relationship Status
                const Text('Relationship Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _selectedRelationshipStatus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.favorite),
                  ),
                  hint: const Text('Select your relationship status'),
                  items: _relationshipOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRelationshipStatus = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Interests
                const Text('Interests (Select at least 4 for better matches)',
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
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Maximum 20 interests allowed')),
                                    );
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
                const Text('Hobbies (Optional)',
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

                // Buttons
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleProfileSetup,
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
                            : const Text('Save Profile',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: _isLoading ? null : _handleSkipForNow,
                        child: const Text('Skip for now', style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleProfileSetup() async {
    if (_interests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one interest')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ProfileService.updateProfile(
        bio: _bioController.text.isEmpty ? null : _bioController.text,
        interests: _interests,
        hobbies: _hobbies.isEmpty ? null : _hobbies,
        age: _ageController.text.isEmpty ? null : int.parse(_ageController.text),
        location: _locationController.text.isEmpty ? null : _locationController.text,
        occupation: _occupationController.text.isEmpty ? null : _occupationController.text,
        gender: _selectedGender,
        relationshipStatus: _selectedRelationshipStatus,
      );

      setState(() => _isLoading = false);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _handleSkipForNow() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _occupationController.dispose();
    super.dispose();
  }
}
