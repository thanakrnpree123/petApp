class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String subscriptionTier;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.subscriptionTier = 'free',
  });

  factory AppUser.fromFirestore(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      email: data['email'] as String,
      displayName: data['display_name'] as String?,
      subscriptionTier: data['subscription_tier'] as String? ?? 'free',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'display_name': displayName,
      'subscription_tier': subscriptionTier,
    };
  }
}
