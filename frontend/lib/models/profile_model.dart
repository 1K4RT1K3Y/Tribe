class Profile {
  final String? id;
  final String userId;
  final String bio;
  final List<String> interests;
  final List<String> hobbies;
  final int? age;
  final String location;
  final String? profileImage;
  final bool verified;
  final String occupation;
  final String gender;
  final String relationshipStatus;
  final bool profileComplete;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    this.id,
    required this.userId,
    this.bio = '',
    this.interests = const [],
    this.hobbies = const [],
    this.age,
    this.location = '',
    this.profileImage,
    this.verified = false,
    this.occupation = '',
    this.gender = 'Prefer not to say',
    this.relationshipStatus = 'Prefer not to say',
    this.profileComplete = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['_id'],
      userId: json['userId'],
      bio: json['bio'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
      hobbies: List<String>.from(json['hobbies'] ?? []),
      age: json['age'],
      location: json['location'] ?? '',
      profileImage: json['profileImage'],
      verified: json['verified'] ?? false,
      occupation: json['occupation'] ?? '',
      gender: json['gender'] ?? 'Prefer not to say',
      relationshipStatus: json['relationshipStatus'] ?? 'Prefer not to say',
      profileComplete: json['profileComplete'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'bio': bio,
      'interests': interests,
      'hobbies': hobbies,
      'age': age,
      'location': location,
      'profileImage': profileImage,
      'verified': verified,
      'occupation': occupation,
      'gender': gender,
      'relationshipStatus': relationshipStatus,
      'profileComplete': profileComplete,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
