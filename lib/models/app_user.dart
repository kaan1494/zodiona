import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { user, admin, astrologer }

class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.birthDate,
    required this.zodiacSign,
    required this.isPremium,
    required this.premiumExpireDate,
    required this.role,
    required this.createdAt,
    required this.onboardingCompleted,
  });

  factory AppUser.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};

    return AppUser(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['name'] as String? ?? '',
      birthDate: (data['birthDate'] as Timestamp?)?.toDate(),
      zodiacSign: data['zodiacSign'] as String? ?? '',
      isPremium: data['isPremium'] as bool? ?? false,
      premiumExpireDate: (data['premiumExpireDate'] as Timestamp?)?.toDate(),
      role: _roleFromString(data['role'] as String?),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      onboardingCompleted: data['onboardingCompleted'] as bool? ?? false,
    );
  }

  final String uid;
  final String email;
  final String displayName;
  final DateTime? birthDate;
  final String zodiacSign;
  final bool isPremium;
  final DateTime? premiumExpireDate;
  final UserRole role;
  final DateTime? createdAt;
  final bool onboardingCompleted;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': displayName,
      'birthDate': birthDate != null ? Timestamp.fromDate(birthDate!) : null,
      'zodiacSign': zodiacSign,
      'isPremium': isPremium,
      'premiumExpireDate': premiumExpireDate != null
          ? Timestamp.fromDate(premiumExpireDate!)
          : null,
      'role': role.name,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'onboardingCompleted': onboardingCompleted,
    };
  }

  AppUser copyWith({
    String? displayName,
    DateTime? birthDate,
    String? zodiacSign,
    bool? isPremium,
    DateTime? premiumExpireDate,
    UserRole? role,
    bool? onboardingCompleted,
  }) {
    return AppUser(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      birthDate: birthDate ?? this.birthDate,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      isPremium: isPremium ?? this.isPremium,
      premiumExpireDate: premiumExpireDate ?? this.premiumExpireDate,
      role: role ?? this.role,
      createdAt: createdAt,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  static UserRole _roleFromString(String? value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'astrologer':
        return UserRole.astrologer;
      default:
        return UserRole.user;
    }
  }
}
