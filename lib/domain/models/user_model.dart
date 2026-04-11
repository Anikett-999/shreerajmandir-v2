import 'package:cloud_firestore/cloud_firestore.dart';

class LocalTimestampConverter {
  const LocalTimestampConverter();

  static DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.tryParse(json);
    return null;
  }

  static dynamic toJson(DateTime? object) {
    if (object == null) return null;
    return Timestamp.fromDate(object);
  }
}

/// Firestore Document: /users/{userId}
///
/// Schema:
/// {
///   userId:    String,
///   name:      String,
///   email:     String,
///   role:      String,   // "admin" | "cashier" | "waiter" — same across ALL branches
///   branchIds: List<String>,  // branches this user can access, e.g. ["branch_001", "branch_002"]
///   isActive:  bool,
///   lastLogin: Timestamp?,
/// }
class UserModel {
  final String userId;
  final String name;
  final String email;

  /// Single role — the user has the same role in every branch they're assigned to.
  final String role; // "admin" | "cashier" | "waiter"

  /// List of branch IDs this user can access.
  final List<String> branchIds;

  final bool isActive;
  final DateTime? lastLogin;
  final String? profileImageUrl;

  const UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    required this.branchIds,
    this.isActive = true,
    this.lastLogin,
    this.profileImageUrl,
  });

  bool get isAdmin => role == 'admin';
  bool get isWaiter => role == 'waiter';
  bool get isCashier => role == 'cashier';

  /// Whether this user has access to a specific branch.
  bool hasAccessToBranch(String branchId) {
    if (isAdmin) return true; // admins access all branches
    return branchIds.contains(branchId);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'waiter',
      branchIds: List<String>.from(json['branchIds'] as List? ?? []),
      isActive: json['isActive'] as bool? ?? true,
      lastLogin: LocalTimestampConverter.fromJson(json['lastLogin']),
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'role': role,
      'branchIds': branchIds,
      'isActive': isActive,
      'lastLogin': LocalTimestampConverter.toJson(lastLogin),
      'profileImageUrl': profileImageUrl,
    };
  }

  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? role,
    List<String>? branchIds,
    bool? isActive,
    DateTime? lastLogin,
    String? profileImageUrl,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      branchIds: branchIds ?? this.branchIds,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
