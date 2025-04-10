class Employee {
  final int id;
  final String name;
  final String role;
  final String? profileImage;  // This is optional (nullable)

  Employee({
    required this.id,
    required this.name,
    required this.role,
    this.profileImage,  // Allow for a null value (no image)
  });

  // Add this method to check if image is an asset
  bool get isAssetImage => profileImage?.startsWith('assets/') ?? false;
  
  // Get image path with fallback
  String get imagePathOrDefault => profileImage ?? 'assets/images/default_profile.png';
}