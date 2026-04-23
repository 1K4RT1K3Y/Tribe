class Match {
  final String userId;
  final String userName;
  final String userEmail;
  final String bio;
  final List<String> interests;
  final List<String> hobbies;
  final int? age;
  final String location;
  final String? profileImage;
  final bool verified;
  final int matchScore;
  final int commonInterests;
  final int commonHobbies;

  Match({
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.bio = '',
    this.interests = const [],
    this.hobbies = const [],
    this.age,
    this.location = '',
    this.profileImage,
    this.verified = false,
    required this.matchScore,
    this.commonInterests = 0,
    this.commonHobbies = 0,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      bio: json['bio'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
      hobbies: List<String>.from(json['hobbies'] ?? []),
      age: json['age'],
      location: json['location'] ?? '',
      profileImage: json['profileImage'],
      verified: json['verified'] ?? false,
      matchScore: json['matchScore'] ?? 0,
      commonInterests: json['commonInterests'] ?? 0,
      commonHobbies: json['commonHobbies'] ?? 0,
    );
  }
}
